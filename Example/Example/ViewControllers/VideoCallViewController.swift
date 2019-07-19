//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import UIKit
import webrtcat4
import AVFoundation

protocol VideoCallViewControllerDelegate: AnyObject {
    func viewControllerDidFinish()
    func receivedCompleted()
    func weWereAlone()
    func calleeRejectedCall()
    func errorBeforeConnecting()
    func errorInCall()
    func clientConnected()
}

class VideoCallViewController: UIViewController {
    
    weak var delegate:VideoCallViewControllerDelegate?
    var client: ARDAppClient!
    var videoCallView: ARDVideoCallView!
    var captureController: ARDCaptureController!
    var remoteVideoTrack: RTCVideoTrack!
    var portOverride: AVAudioSession.PortOverride!
    
    var callInitiated = false
    var managingAutomaticReconnect = false
    var disconectedManaged = false
    var callRejected = false
    var mustShowError = false

    convenience init(roomId: String, calleeId: String, delegate: VideoCallViewControllerDelegate ) {
        self.init()
        
        self.delegate = delegate
        
        WebRTCCallManager.sharedInstance.isCaller = true
        WebRTCCallManager.sharedInstance.calleeId = calleeId
        WebRTCCallManager.sharedInstance.roomId = roomId
        
        client = ARDAppClient(delegate: self, serverURL: "\(SERVER_HOST_URL)")
        client.isCaller = true
        client.shouldGetStats = true
        
        initClient()
    }
    
    convenience init(roomId: String, callerId: String, delegate: VideoCallViewControllerDelegate ) {
        self.init()
        
        self.delegate = delegate
        
        WebRTCCallManager.sharedInstance.isCaller = false
        WebRTCCallManager.sharedInstance.callerId = callerId
        WebRTCCallManager.sharedInstance.roomId = roomId
        
        client = ARDAppClient(delegate: self, serverURL: "\(SERVER_HOST_URL)")
        client.isCaller = false
        initClient()
    }
    
    func connect(){
        let settingsModel = ARDSettingsModel()
        
        guard let room = WebRTCCallManager.sharedInstance.roomId else{
            return
        }
        client.connectToRoom(withId: room, settings: settingsModel, isLoopback: false)
    }
    
    func initClient(){
        client.setSTUNServer("stun:stun.l.google.com:19302")
        client.addRTCICEServer(TURN_SERVER_UDP, username: TURN_SERVER_UDP_USERNAME, password: TURN_SERVER_UDP_PASSWORD)
        client.addRTCICEServer(TURN_SERVER_TCP, username: TURN_SERVER_TCP_USERNAME, password: TURN_SERVER_TCP_PASSWORD)
    }
    
    override func loadView() {
        self.videoCallView = ARDVideoCallView(frame: CGRect.zero)
        self.videoCallView.backgroundColor = .black
        self.videoCallView.delegate = self
        self.videoCallView.statusLabel.text = self.statusTextFor(state: RTCIceConnectionState.new)
        self.view = self.videoCallView
        let session = RTCAudioSession.sharedInstance()
        session.add(self)
        UIApplication.shared.isIdleTimerDisabled = true
        self.connect()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func statusTextFor(state: RTCIceConnectionState) -> String{
        switch (state) {
        case RTCIceConnectionState.new:
            break
        case RTCIceConnectionState.checking:
            return "Connecting..."
        case RTCIceConnectionState.connected:
            break
        case RTCIceConnectionState.completed:
            break
        case RTCIceConnectionState.failed:
            break
        case RTCIceConnectionState.disconnected:
            break
        case RTCIceConnectionState.closed:
            break
        case RTCIceConnectionState.count:
            break
        default:
            break
        }
        
        return ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        WebRTCCallManager.sharedInstance.roomId = nil
        UIApplication.shared.isIdleTimerDisabled = false
        client = nil
        videoCallView = nil
        captureController = nil
        remoteVideoTrack = nil
        
    }
    
    func rejectedCall(){
        callRejected = true
    }
    
    func hangUp(dismiss: Bool){
        self.remoteVideoTrack = nil
        
        if videoCallView != nil{
            videoCallView.localVideoView.captureSession = nil
        }
        
        if captureController != nil{
            captureController.stopCapture()
            captureController = nil
        }
        
        if dismiss{
            delegate?.viewControllerDidFinish()
        }
        
        if client != nil{
            client.disconnect()
            self.client = nil
        }
        
        
        let session = RTCAudioSession.sharedInstance()
        session.isAudioEnabled = false
        
    }
    
    func disconnect(){
        self.remoteVideoTrack = nil
        
        if videoCallView != nil{
            videoCallView.localVideoView.captureSession = nil
        }
        
        if captureController != nil{
            captureController.stopCapture()
            captureController = nil
        }
        
        if client != nil{
            client.disconnect()
            
        }
        
        
        let session = RTCAudioSession.sharedInstance()
        session.isAudioEnabled = false
        
        self.client = nil
    }
    
    
    
    func calleeStartCall(){
        if client != nil{
            client.calleAcceptCall()
        }
    }
    
    func manageDisconnected(){

        if disconectedManaged{
            return
        }
        
        disconectedManaged = true
        
        if self.managingAutomaticReconnect{
            self.managingAutomaticReconnect = false
            return
        }
        
        if self.callInitiated{
            self.hangUp(dismiss: !mustShowError)
        }
        else{
            if WebRTCCallManager.sharedInstance.isCaller != nil{
                if WebRTCCallManager.sharedInstance.isCaller! && !mustShowError{
                    self.delegate?.calleeRejectedCall()
                }
                else if !WebRTCCallManager.sharedInstance.isCaller!{
                    
                    hangUp(dismiss: !mustShowError)
                }
            }
            
        }
    }
}

extension VideoCallViewController: ARDVideoCallViewDelegate{
    func videoCallViewDidSwitchCamera(_ view: ARDVideoCallView!) {
        captureController.switchCamera()
    }

    func videoCallViewDidHangup(_ view: ARDVideoCallView!) {
        self.hangUp(dismiss: true)
    }
}

extension VideoCallViewController: RTCAudioSessionDelegate{
    
}

extension VideoCallViewController: ARDAppClientDelegate{
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
     
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch (state) {
        case .connected:
            if let isCaller =  WebRTCCallManager.sharedInstance.isCaller{
                if !isCaller{
                    delegate?.clientConnected()
                }
            }
            break
        case .connecting:
            break
        case .disconnected:
            manageDisconnected()
            break
        }
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {

        if state.rawValue == 1{
            
            Timer.after(3.seconds) {
                if !self.callInitiated{
                    if WebRTCCallManager.sharedInstance.isCaller != nil{
                        if WebRTCCallManager.sharedInstance.isCaller!{
                            
                        }
                    }
                }
            }
        }
        else if state.rawValue == 2{
            if !WebRTCCallManager.sharedInstance.isCaller!{
                self.callInitiated = true
            }
            else{
                if WebRTCCallManager.sharedInstance.isCaller!{
                    self.callInitiated = true
                }
            }
            delegate?.receivedCompleted()
            
        }
        else if state.rawValue == 5{
            manageDisconnected()
        }
        else if state.rawValue == 6{
            manageDisconnected()
        }
        
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        if videoCallView != nil{
            videoCallView.localVideoView.captureSession = localCapturer.captureSession
        }
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController.startCapture()
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        
        if (self.remoteVideoTrack == remoteVideoTrack) {
            return
        }
        
        if self.remoteVideoTrack != nil{
            self.remoteVideoTrack.remove(videoCallView.remoteVideoView)
            self.remoteVideoTrack = nil
        }
        
        
        videoCallView.remoteVideoView.renderFrame(nil)
        self.remoteVideoTrack = remoteVideoTrack
        remoteVideoTrack.add(videoCallView.remoteVideoView)
        
        if client.checkIfWeAreAlone(){
            self.delegate?.weWereAlone()
        }
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        
        if !callInitiated{
            mustShowError = true
            delegate?.errorBeforeConnecting()
        }
        else{
            mustShowError = true
            delegate?.errorInCall()
        }
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalFileCapturer fileCapturer: RTCFileVideoCapturer!) {
        
    }
}

