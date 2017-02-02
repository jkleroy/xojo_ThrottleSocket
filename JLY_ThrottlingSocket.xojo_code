#tag Class
Protected Class JLY_ThrottlingSocket
Inherits xojo.net.httpsocket
	#tag Event
		Sub PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
		  #if not DebugBuild
		    RaiseEvent PageReceived(URL, HTTPStatus, Content)
		    Return
		  #endif
		  if self.throttling = throttlingTypes.None then
		    RaiseEvent PageReceived(URL, HTTPStatus, Content)
		    Return
		  end if
		  
		  realBytesReceived = content.Size
		  
		  
		  
		  Dim delay As Integer
		  
		  
		  
		  delay = (xojo.core.Date.Now.SecondsFrom1970-startCallSeconds)*1000
		  
		  
		  mwait = Content.Size / (downKBs/8) + delayMS-delay
		  
		  //Don't wait if less than a millisecond
		  if mwait <= 1 then
		    mWait = 0
		    
		    RaiseEvent PageReceived(URL, HTTPStatus, Content)
		    
		  Else
		    data = new xojo.Core.Dictionary
		    data.Value("url") = URL
		    data.Value("httpstatus") = HTTPStatus
		    data.Value("Content") = Content
		    
		    System.DebugLog("ThrottlingSocket waiting: " + mwait.ToText + "ms")
		    
		    xojo.core.timer.CallLater(mwait, WeakAddressOf handlePageReceived)
		    
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub ReceiveProgress(BytesReceived as Int64, TotalBytes as Int64, NewData as xojo.Core.MemoryBlock)
		  #if not DebugBuild
		    RaiseEvent ReceiveProgress(BytesReceived, TotalBytes, NewData)
		    Return
		  #endif
		  
		  if self.throttling = throttlingTypes.None then
		    RaiseEvent ReceiveProgress(BytesReceived, TotalBytes, NewData)
		    Return
		  end if
		  
		  self.realBytesReceived = BytesReceived
		  self.TotalBytes = TotalBytes
		  
		  if startedReceiving is nil then
		    startedReceiving = xojo.core.Date.Now
		    self.BytesReceived = BytesReceived / (downKbs/8)
		    RaiseEvent ReceiveProgress(self.bytesReceived, totalBytes, NewData)
		  end if
		  
		  
		  
		  xojo.core.timer.CancelCall(AddressOf handleBytesReceived)
		  
		  xojo.core.timer.CallLater(100, AddressOf handleBytesReceived)
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  self.throttling = throttlingTypes.Regular_3G
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  xojo.core.timer.CancelCall WeakAddressOf handlePageReceived
		  xojo.core.timer.CancelCall WeakAddressOf handleBytesReceived
		  
		  super.Disconnect()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub handleBytesReceived()
		  
		  
		  
		  Dim elapsed As Double = (xojo.core.Date.Now.SecondsFrom1970-startedReceiving.SecondsFrom1970)
		  
		  bytesReceived = min(realBytesReceived, (downKBs/8) * elapsed * 1000)
		  
		  //System.DebugLog("Elapsed: " + elapsed.ToText + " seconds    Received: " + bytesReceived.ToText + "   " + "Total: " + TotalBytes.ToText)
		  
		  RaiseEvent ReceiveProgress(BytesReceived, totalBytes, nil)
		  
		  
		  if bytesReceived < realBytesReceived then
		    xojo.core.timer.CallLater(100, AddressOf handleBytesReceived)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub handlePageReceived()
		  
		  xojo.core.timer.CancelCall(AddressOf handleBytesReceived)
		  
		  Dim url As Text
		  Dim httpStatus As Integer
		  Dim content As xojo.Core.MemoryBlock
		  
		  url = data.Value("url")
		  httpStatus = data.Value("httpStatus")
		  content = data.Value("content")
		  
		  RaiseEvent PageReceived(url, httpstatus, content)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Send(Method as Text, URL as Text)
		  
		  startedReceiving = nil
		  
		  startCallSeconds = xojo.core.Date.Now.SecondsFrom1970
		  
		  
		  super.Send(Method, URL)
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceiveProgress(BytesReceived as Int64, TotalBytes as Int64, NewData As xojo.Core.MemoryBlock)
	#tag EndHook


	#tag Note, Name = About
		
		https://www.jeremieleroy.com
		
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private bytesReceived As Int64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private data As xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		delayMS As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		downKbs As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mthrottling As throttlingTypes
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWait As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private realBytesReceived As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		startCallSeconds As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private startedReceiving As xojo.core.date
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mthrottling
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mthrottling = value
			  
			  Select Case value
			    
			  Case throttlingTypes.None
			    delayMS = -1
			    downKBs = -1
			    upKBs = -1
			    
			  Case throttlingTypes.GPRS
			    delayMS = 500
			    downKBs = 50
			    upKBs = 20
			    
			  Case throttlingTypes.Regular_2G
			    delayMS = 300
			    downKBs = 250
			    upKBs = 50
			    
			  Case throttlingTypes.Good_2G
			    delayMS = 150
			    downKBs = 450
			    upKBs = 150
			    
			  Case throttlingTypes.Regular_3G
			    delayMS = 100
			    downKBs = 750
			    upKBs = 250
			    
			  Case throttlingTypes.Good_3G
			    delayMS = 40
			    downKbs = 1500
			    upKbs = 750
			    
			  Case throttlingTypes.Regular_4G
			    delayMS = 20
			    downKbs = 4000
			    upKbs = 3000
			    
			  Else
			    //Unknown throttling
			    Break
			  End Select
			End Set
		#tag EndSetter
		throttling As throttlingTypes
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private TotalBytes As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		upKbs As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41646465642064656C617920696E206D696C6C697365636F6E647320746F207365727665207468652072657175657374
		#tag Getter
			Get
			  return mWait
			End Get
		#tag EndGetter
		Wait As Double
	#tag EndComputedProperty


	#tag Constant, Name = kReleaseDate, Type = Double, Dynamic = False, Default = \"20170202", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Text, Dynamic = False, Default = \"1.0.0", Scope = Public
	#tag EndConstant


	#tag Enum, Name = throttlingTypes, Type = Integer, Flags = &h0
		None
		  GPRS
		  Regular_2G
		  Good_2G
		  Regular_3G
		  Good_3G
		Regular_4G
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="delayMS"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="downKbs"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="startCallSeconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="throttling"
			Group="Behavior"
			Type="throttlingTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - GPRS"
				"2 - Regular_2G"
				"3 - Good_2G"
				"4 - Regular_3G"
				"5 - Good_3G"
				"6 - Regular_4G"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="upKbs"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ValidateCertificates"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Wait"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
