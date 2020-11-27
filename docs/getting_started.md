# Getting Started

The MBMobileSDK allows third party apps to connect into the Daimler eco system and communicate with vehicles. 
This guide will describe first steps for developers. As such it will cover how to integrate the SDK into your application, configure the SDK and how to fetch data or send commands.

*Please be aware that most of these steps depend on the previous section. It is not recommended to skip any parts of this guide.*

We provide an example app, that has a completely functional SDK integration with all the above mentioned features. We provide an example app, that has a completely functional SDK integration with all the above mentioned features. It can be found in this repository within the `Example` folder.


## Table of Contents
[Organisational](#organisational)

[Integrate the MBMobileSDK](#integrate-the-mbmobilesdk)

[Setup](#setup)

[Showing the login view](#showing-the-login-view)

[Selecting a vehicle](#selecting-a-vehicle)

[Connecting to the vehicle](#connecting-to-the-vehicle)

[Retrieving a value once](#retrieving-a-value-once)

[Observing a value](#observing-a-value)

[Sending car commands ](#sending-car-commands)

[Logout](#logout)

## Organisational
Register as a developer on the [Mercedes-Benz Developers Portal](https://developer.mercedes-benz.com).
Here you have to create an app to create app id's and get your application approved for production usage. More information about the approval process is available on the 
developer site. However, for testing against mock and simulated vehicles, no approval process is necessary. In the developer portal it is possible to skip this step for now and
continue with the guide.    

This registration is also valid vor the car simulator, which will be a huge help during the development and testing process. The simulator can be found [here](https://developer.mercedes-benz.com/car-simulator).

The simulator allows you to test your code on a simulated car. After login you should have multiple mock vehicles available. After selecting one of the cars you should see an image of the car in the center of the screen. On the right hand side there is a menu with two items.

On the right side the menu `Capabilities` allows the user to change vehicle values, such as unlocking doors or staring the engine. `Trip Simulator` allows for creation of trips. During a trip vehicle values are changed dynamically over time. This can be useful for testing the continuous observation of values.

## Integrate the MBMobileSDK

### CocoaPods

MBMobileSDK is available using [CocoaPods](https://cocoapods.org). To integrate it add the following line to your podfile:

```cocoapods
use_frameworks!

target 'MyApp' do
  pod 'MBMobileSDK'
end
```

Next you will need to install the pod running:

```bash
pod install
```

As usual with cocoapods you will have to work with the generated `MyApp.xcworkspace`.
The SDK is divided into multiple modules, which will all be installed into your project by pods. However this means that different parts of the SDK
will need separate import statements. For this reason all code blocks in this guide show the correct import in the first line. Obviously the import should not be part of the class or method but as usually at the beginning of the file.

### Swift Package Manager

MBMobileSDK is available using [Swift Package Manager](https://swift.org/package-manager/). To include MBMobileSDK add it in `dependencies` in your `Package.swift`:

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ExampleProject",
    dependencies: [
        .package(name: "MBMobileSDK", url: "https://github.com/Daimler/MBSDK-Mobile-iOS.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "ExampleProject",
            dependencies: ["MBMobileSDK"]),
    ]
)
```


## Setup

The SDK has to be configured with some dynamic parameters which have to be provided by the SDK consumer.

The following parameters can be configured:

 | Parameter     | Type        | Optional | Description | 
 | ------------- |-------------|----------|-------------|
 | applicationIdentifier | String | no | The id of the application used for distinction |
 | authenticationConfigs | Array | no | Array of ROPCAuthenticationConfig. For config see below. |
 | endpointRegion | String | no | The region where this application is running. |
 | endpointStage | String | no | The endpoint to access. You should start with mock, for prod access the above mentioned review process has to pass. |
 | preferredAuthMethod | Enum | no | The preferred authentication type. |


Setup of OPCAuthenticationConfig:
  | Parameter     | Type        | Optional | Description | 
 | ------------- |-------------|----------|-------------|
 | clientId | String | no | The Identifier created in the [Mercedes-Benz Developers Portal](https://developer.mercedes-benz.com) |
 | type | Enum | no | The authentication type. |

 With the smallest configuration you will end up with something like this:
 
 ```swift
import MBMobileSDK

let authConfig = ROPCAuthenticationConfig(clientId: "app", type: .ciam)

let config = MBMobileSDKConfiguration(applicationIdentifier: "example",
                                        authenticationConfigs: [authConfig],
                                        endpointRegion: "ece",
                                        endpointStage: "prod",
                                        preferredAuthMethod: .ciam)
```

Use the created configuration to setup the sdk.
```swift
import MBMobileSDK

MobileSDK.setup(configuration: config)
```

## Login

Login with an existing user can be done via one-time password (OTP), witch will be sent to the email or mobile phone number to the associated user. First you have to iniciate that process by calling following function with existing username (email or mobile phone number):

```swift
import MBMobileSDK
IngressKit.loginService.doesUserExist(username: "") { (result) in
    switch result {
    case .failure(let error):
    // Handle error.
    case .success(let userExistModel):
    // Continue with login process.
    }
}
```

If this function finishes with success, an 6-digit one-time password (OTP) was sent via email or SMS to that user. You can use that OTP to login.

```swift
import MBMobileSDK
IngressKit.loginService.login(username: "", pin: "123456") { (result) in
    switch result {
    case .failure(let error):
    // Handle error.
    case .success(let userModel):
    // Successfully logged in.
    }
}
```

## Selecting a vehicle
For most of the functionality either a Vehicle Identification Number (VIN) has to be passed to the calls or the vehicle has to be selected within the SDK.
First we retrieve a list of vehicles from which we will choose one to interact with:

```swift
import MBMobileSDK

CarKit.vehicleService.fetchVehicles { (result) in
    switch result {
    case .failure(let error):
    // Handle error.
    case .success(let vehicles):
    // vehicles is a array of VehicleModel.
   }
}
```

Now a vehicle has to be selected. In your application you should probably show some UI to the use for the selection process. We just assume 
that a vehicle was chosen. The `vehicle` object in this code block is one of the objects of the above array.

```swift
import MBMobileSDK

CarKit.selectVehicle(with: vehicle.finOrVin) { (result) in
    switch result {
    case .failure(let error):
    // Handle error.
    case .success:
    // vehicle is now selected, you can proceed with your app flow.
    }
}
``` 

If you do not care about which vehicle is selected, then there is a quick selection process. This can be very useful for testing. To use it
simply call:

```swift
import MBMobileSDK

CarKit.vehicleService.instantSelectVehicle(){ (finOrVin) in
    // vehicle is now selected, you can proceed with additional calls
}
```

The optional string of the closure parameter is the vehicle identification of the selected car.

## Connecting to the vehicle

I will demonstrate how to get and observe values using the door state. This value describes if the car doors are locked or unlocked.
First thing you have to do is connecting to the car. For this you have to create a `SocketObservableProtocol`.
This object will be important for fetching values once and observing them. We will need a member variable in which to store the created object.

```swift
import MBMobileSDK

private var observable: SocketObservableProtocol?
```

Now we can create the observable object by connecting to the socket.  

```swift
import MBMobileSDK

self.observable = CarKit.socketService.connect(
        notificationTokenCreated: { (token: MyCarSocketNotificationToken?) -> Void in
        }, socketConnectionState: { [weak self] state in
    switch (state) {
    case .connected:
        print("connected")
            // connected, everything is good do some vehicle work
    case .closed, .connecting, .disconnected, .connectionLost:
        print("error on connect")
            // not connect, oops
    }
}).socketObservable
```

If everything works as intended the connection state closure should be called with a state `connected`. The different states should be self explanatory. 
Ignore the Token notification for now.  

## Retrieving a value once

At this point a reminder to please follow these topics one by one. At least make sure you did [Selecting a vehicle](#selecting) and [Connecting to the vehicle](#connecting). 
A car has to be selected and connected for the following steps to work out.
  
Now we have a look at how to fetch a value. All the vehicle properties can be fetched in a similar manner. As stated above you can check if the car doors are unlocked.
Using the observable from above the following code will yield us a lockState from which you can deduce if the front left door is unlocked or locked.

```swift
import MBMobileSDK

let state = self.observable?.doors.current.frontLeft.lockState
let value = state?.value
if(value == .locked){
    // door front left is locked
} else {
    // door front left is unlocked
}
``` 

Other vehicle attributes can be fetched in a similar manner.

## Observing a value 

A lot of the values of a car can continuously change. A good example would be the fuel level. It is desirable to be informed about a change in these values from the SDK without having to actively keep polling. This is possible by observing the value. As an example I will continue with the lock state of the doors to keep consistent.

First you need a `Disposal` to be able to clean up our observation later on. So you have to add it next to the `observable` from earlier as another member variable:

```swift
import MBMobileSDK

private var disposal = Disposal()
private var observable: SocketObservableProtocol?
```

Now *after* connecting to the socket as described in [Connecting to the vehicle](#connecting) you can observe the doors. You also have to add the observer to the disposable.

```swift
import MBMobileSDK

self.observable?.doors.observe({ [] (state) in
                        switch (state) {
                        case .initial(let doors):
                            print("Doors initial state: \(doors.statusOverall)")
                        case .updated(let doors):
                            print("Doors updated state: \(doors.statusOverall)")
                        }
                    }).add(to: &strongSelf.disposal)
```
The initial case is called once with the current value of the observed object. When the state changes a call with state update will be received.

After you finished observing you have to remove the observer.

```swift
import MBMobileSDK

self.disposal.removeAll()
```

Here the complete example. At this point we recommend to have a look at the example app.

```swift
import Foundation
import MBMobileSDK

class ObserverTest {
    private var disposal = Disposal()
    private var observable: SocketObservableProtocol?

    public init() {

        self.observable = CarKit.socketService.connect(
                notificationTokenCreated: { (token: MyCarSocketNotificationToken?) -> Void in
                }, socketConnectionState: { [weak self] state in
            switch (state) {
            case .connected:
                print("connected")
                if let strongSelf = self {
                    strongSelf.observable?.doors.observe({ [] (state) in
                        switch (state) {
                        case .initial(let doors):
                            print("Doors initial state: \(doors.statusOverall)")
                        case .updated(let doors):
                            print("Doors updated state: \(doors.statusOverall)")
                        }
                    }).add(to: &strongSelf.disposal)
                }
            case .closed, .connecting, .disconnected, .connectionLost:
                print("error on connect")

            }
        }).socketObservable

    }

    deinit {
        self.disposal.removeAll()
    }

}
```

## Sending car commands 

Now the last topic explains how to send commands. A command is a call to the car which is executed by the vehicle. 
Locking doors is a very good use case to demonstrate this functionality.

Commands are called as such in the SDK. This is how a command is created and send to the car. Again make sure you followed [Selecting a vehicle](#selecting) and [Connecting to the vehicle](#connecting). Sending the following command will lock the selected vehicles doors.

```swift
 CarKit.socketService.send(command: Command.DoorsLock(), completion: { (commandProcessingState, _) in
            completion()
            switch commandProcessingState {
            case .finished:
                print("Command lock doors successfully executed")
            case .failed(errors: let error):
                print("Command lock doors failed with error: \(error)")
            case .updated(state: let state):
                print("Command lock doors updated - state: \(state)")
            }
        })
```
Other commands can be executed in a similar fashion.

## Logout
The SDK provides a convenience method for a logout.

```swift
MobileSDK.doLogout()
```
