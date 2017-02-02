#tag IOSView
Begin iosView View1
   BackButtonTitle =   ""
   Compatibility   =   ""
   Left            =   0
   NavigationBarVisible=   True
   TabIcon         =   ""
   TabTitle        =   ""
   Title           =   "Throttle HTTPSocket"
   Top             =   0
   Begin iOSButton Button1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   Button1, 7, , 0, False, +1.00, 1, 1, 100, 
      AutoLayout      =   Button1, 9, <Parent>, 9, False, +1.00, 1, 1, 0, 
      AutoLayout      =   Button1, 3, ProgressBar1, 4, False, +1.00, 1, 1, *kStdControlGapV, 
      AutoLayout      =   Button1, 8, , 0, False, +1.00, 1, 1, 30, 
      Caption         =   "Download "
      Enabled         =   True
      Height          =   30.0
      Left            =   110
      LockedInPosition=   False
      Scope           =   0
      TextColor       =   &c007AFF00
      TextFont        =   ""
      TextSize        =   0
      Top             =   85
      Visible         =   True
      Width           =   100.0
   End
   Begin iOSTable Table1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   Table1, 4, <Parent>, 4, False, +1.00, 1, 1, -0, 
      AutoLayout      =   Table1, 1, <Parent>, 1, False, +1.00, 1, 1, 0, 
      AutoLayout      =   Table1, 2, <Parent>, 2, False, +1.00, 1, 1, -0, 
      AutoLayout      =   Table1, 3, Label1, 4, False, +1.00, 1, 1, *kStdControlGapV, 
      EditingEnabled  =   False
      EditingEnabled  =   False
      EstimatedRowHeight=   -1
      Format          =   "0"
      Height          =   270.0
      Left            =   0
      LockedInPosition=   False
      Scope           =   0
      SectionCount    =   0
      Top             =   210
      Visible         =   True
      Width           =   320.0
   End
   Begin JLY_ThrottlingSocket socket
      delayMS         =   0
      downKbs         =   0
      Left            =   0
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   0
      startCallSeconds=   0.0
      throttling      =   ""
      Top             =   0
      upKbs           =   0
      ValidateCertificates=   False
      Wait            =   0.0
   End
   Begin iOSProgressBar ProgressBar1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   ProgressBar1, 8, , 0, True, +1.00, 1, 1, 20, 
      AutoLayout      =   ProgressBar1, 1, Table1, 1, False, +1.00, 1, 1, 0, 
      AutoLayout      =   ProgressBar1, 2, Table1, 2, False, +1.00, 1, 1, 0, 
      AutoLayout      =   ProgressBar1, 3, TopLayoutGuide, 4, False, +1.00, 1, 1, -8, 
      Height          =   20.0
      Left            =   0
      LockedInPosition=   False
      MaxValue        =   100.0
      MinValue        =   0.0
      Scope           =   0
      Top             =   57
      Value           =   0.0
      Visible         =   True
      Width           =   320.0
   End
   Begin iOSLabel Label1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   Label1, 8, , 0, False, +1.00, 1, 1, 79, 
      AutoLayout      =   Label1, 1, <Parent>, 1, False, +1.00, 1, 1, *kStdGapCtlToViewH, 
      AutoLayout      =   Label1, 2, <Parent>, 2, False, +1.00, 1, 1, -*kStdGapCtlToViewH, 
      AutoLayout      =   Label1, 3, Button1, 4, False, +1.00, 1, 1, *kStdControlGapV, 
      Enabled         =   True
      Height          =   79.0
      Left            =   20
      LineBreakMode   =   "0"
      LockedInPosition=   False
      Scope           =   0
      Text            =   "Untitled"
      TextAlignment   =   "1"
      TextColor       =   &c00000000
      TextFont        =   ""
      TextSize        =   0
      Top             =   123
      Visible         =   True
      Width           =   280.0
   End
End
#tag EndIOSView

#tag WindowCode
	#tag Property, Flags = &h0
		startTime As xojo.Core.Date
	#tag EndProperty


#tag EndWindowCode

#tag Events Button1
	#tag Event
		Sub Action()
		  
		  socket.Disconnect()
		  Label1.Text = "Downloading..."
		  ProgressBar1.Value = 0
		  
		  startTime = xojo.core.date.Now
		  
		  
		  socket.Send("GET", "https://www.jeremieleroy.com/upload/testfile_500k")
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Table1
	#tag Event
		Sub Action(section As Integer, row As Integer)
		  
		  Dim cell As iOSTableCellData
		  
		  For i as Integer = 0 to me.RowCount(section)-1
		    
		    
		    cell = me.RowData(section, i)
		    if i <> row and cell.AccessoryType = iOSTableCellData.AccessoryTypes.Checkmark then
		      cell.AccessoryType = iOSTableCellData.AccessoryTypes.None
		      me.ReloadRow(section, i)
		    end if
		    
		  Next
		  
		  cell = me.RowData(section, row)
		  cell.AccessoryType = iOSTableCellData.AccessoryTypes.Checkmark
		  socket.throttling = cell.Tag
		  me.ReloadRow(section, row)
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  
		  Dim cell As iOSTableCellData
		  
		  me.AddSection("Select Network Type")
		  
		  Cell = me.CreateCell("None")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.None
		  cell.AccessoryType = iOSTableCellData.AccessoryTypes.Checkmark
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("GPRS", "Delay: 500ms, Down: 50Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.GPRS
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("Regular 2G", "Delay: 300ms, Down: 450Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.Regular_2G
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("Good 2G", "Delay: 150ms, Down: 450Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.Good_2G
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("Regular 3G", "Delay: 100ms, Down: 750Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.Regular_3G
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("Good 3G", "Delay: 40ms, Down: 1500Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.Good_3G
		  me.AddRow(0, Cell)
		  
		  Cell = me.CreateCell("Regular 4G", "Delay: 20ms, Down: 4000Kb")
		  Cell.Tag = JLY_throttlingSocket.throttlingTypes.Regular_4G
		  me.AddRow(0, Cell)
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events socket
	#tag Event
		Sub PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
		  
		  if HTTPStatus <> 200 then
		    
		    //an error happened
		    Break
		    Return
		  end if
		  
		  Dim dlTime As Double = xojo.core.date.Now.SecondsFrom1970 - startTime.SecondsFrom1970
		  
		  label1.text = "500k file downloaded in " + dlTime.ToText + " seconds with " +_
		  me.Wait.ToText(locale.Current, "#,###") + " milliseconds delay"
		End Sub
	#tag EndEvent
	#tag Event
		Sub ReceiveProgress(BytesReceived as Int64, TotalBytes as Int64, NewData As xojo.Core.MemoryBlock)
		  
		  ProgressBar1.Value = BytesReceived / TotalBytes * 100
		End Sub
	#tag EndEvent
	#tag Event
		Sub Error(err as RuntimeException)
		  
		  Label1.Text = err.Reason
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Label1
	#tag Event
		Sub Open()
		  me.Text = ""
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackButtonTitle"
		Group="Behavior"
		Type="Text"
		EditorType="MultiLineEditor"
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
		Name="NavigationBarVisible"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIcon"
		Group="Behavior"
		Type="iOSImage"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabTitle"
		Group="Behavior"
		Type="Text"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Group="Behavior"
		Type="Text"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
