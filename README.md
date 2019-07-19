WebRTCat4 iOS client
====================

![Cocoapods](https://img.shields.io/cocoapods/v/webrtcat4.svg)

This project contains the WebRTCat4 client application for iOS as well as a reusable iOS module that can be included in other projects.

## Use WebRTCat4 in your iOS project

### Using it as remote Cocoapod

Declare WebRTCat 4 iOS client as dependency in your `Podfile`:

```
pod 'webrtcat4', :git => 'https://github.com/seg-i2CAT/webrtcat4_ios.git', :branch => '4.0.0'
```

### Using it as local CocoaPod

If you want to develop over the project itself, copy source code and use option `:path`.

```
pod 'webrtcat4', :path => '~../webrtcat4/'
```

# Developing your app

## ⚠️ Bitcode

It is important to note that it is not possible enabling Bitcode for webrtcat4 CocoaPod. More information could be found [here](https://webrtc.org/native-code/ios/).

To disable Bitcode, after CocoaPods installation (`pod install`), go to Pods -> Build Settings -> TARGETS -> webrtcat4 -> Build options -> Enable Bitcode and establish the value to No.

## Steps to create your own app

- Create local variables in View Controller associated with local/remote video tracks and local capturer:

```
var localVideoTrack: RTCVideoTrack?
var remoteVideoTrack: RTCVideoTrack?
var localCapturer: RTCCameraVideoCapturer?
var captureController:ARDCaptureController?
```

- Implement `ARDAPPClientDelegate`, `RTCEAGLVideoViewDelegate`, `RTCVideoViewDelegate` from `webrtcat4` in VC

Callbacks called from client. See example application for an implementation guide:

* ```func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState)```
* ```func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState)```
* ```appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!):``` local capturer. Sets the value in localCapturer and starts capturing.
* ```appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!)```: Sets the value in localVideoTrack.
* ```appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!)```: Sets the value in remoteVideoTrack.
* ```appClient(_ client: ARDAppClient!, didError error: Error!)```: Callback application Error
* ```appClient(_ client: ARDAppClient!, callStart message: String!)```: Callback on call start
* ```appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!)```: Callback on get stats
* ```videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize): RTCEAGLVideoViewDelegate```

Configure your application for camera and microphone usage: in your application `Info.plist` set `NSMicrophoneUsageDescription` and `NSCameraUsageDescription.`

# Application example

App Example is based on GoogleWebRTC example. WebRTCat4 Example App relies on Firebase Cloud Messaging for asynchronous messaging from server side, Collider for WebsSockets and a Node.js server application for rooms/users server.

Because configuration is different between installations, some changes have to be made in application config files.

To make the sample app work:

- Modify `Constants.swift`. Configure each property with proper values.
- Add your own `GoogleService-Info.plist` with  Firebase configuration.

# License

WebRTCat 4 iOS client is offered under MIT license ([LICENSE](LICENSE))

Third party code used in this project is described in the file [LICENSE_THIRD_PARTY](LICENSE_THIRD_PARTY).

