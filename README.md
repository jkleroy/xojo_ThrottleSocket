# xojo_ThrottleSocket

An extension to Xojo.Net.HTTPSocket to include network throttling.

Testing an app in the iOS Simulator is usually done with a broadband or cable network. This means that network speed will be extremely high compared to some users running your app on their cellular network.

A good UI design implies that the user should know what is happening as soon as a button is pushed.
Some network request might seem extremely fast in the simulator and not need a Progress wheel for example, but the reality might be very different.

This class will help you check how slow your App can be when used on cellular networks.

For security purposes, the ThrottleSocket will not apply any delay in production (built) apps.

https://www.jeremieleroy.com

## Testing the socket

* Pre-requisites:
  * Xojo 2016r2
* Download the Xojo project
* Run in iOS Simulator
* Select a Network type and hit the **Download** button

(https://www.jeremieleroy.com/files/news/2017/xojo_ThrottleSocket.png)

## Install in your app

Simply copy the **JLY_ThrottlingSocket** class to your project.
Then set the Super property of all xojo.Net.HTTPSocket to JLY_ThrottlingSocket

In JLY_ThrottlingSocket.Constructor, change the throttlingType to the type of network you would like to test:

`self.throttling = throttlingTypes.Regular_3G`

Run your app and see how slow it can get for your users.