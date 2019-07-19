//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit
import AVFoundation
import SwiftyTimer

class CallContainerViewController: UIViewController {

    @IBOutlet weak var containerInCallView: UIView!
    @IBOutlet weak var containerPreCallView: UIView!

    var videoCall: VideoCallViewController!
    var callingVC: CallingViewController!
    var incoming: IncomingViewController!
    var cancelTimer: Timer!

    var isCaller = false
    var roomId: String?
    var callerId: String?
    var calleeId: String?
    var errorPer = false
    
    var calleeName: String?
    var callerName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isCaller{
           videoCall = VideoCallViewController(roomId: roomId!, callerId: callerId!, delegate: self)
        }
        else{
            videoCall = VideoCallViewController(roomId: roomId!, calleeId: calleeId!, delegate: self)
        }
         addCallViewController()

        setInitialAppereance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showingCallVC = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showingCallVC = nil
     
        WebRTCCallManager.sharedInstance.calleeId = nil
        WebRTCCallManager.sharedInstance.callerId = nil
        WebRTCCallManager.sharedInstance.roomId = nil
        WebRTCCallManager.sharedInstance.isCaller = nil
    }
    
    func checkForPermissions(){
        incoming.agafarButton.isHidden = true
        incoming.cancelarButton.isHidden = true

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized && AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized {
            incoming.agafarButton.isHidden = false
            incoming.cancelarButton.isHidden = false
        } else {
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.incoming.agafarButton.isHidden = false
                            self.incoming.cancelarButton.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorPopupMicrophone()
                            self.hangUpPermissions()

                        }
                        
                    }
                })
            }
            else if AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.incoming.agafarButton.isHidden = false
                            self.incoming.cancelarButton.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorPopupVideo()
                            self.hangUpPermissions()

                        }
                        
                    }
                })
            }
            else{
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
                            if granted {
                                DispatchQueue.main.async {
                                    self.incoming.agafarButton.isHidden = false
                                    self.incoming.cancelarButton.isHidden = false
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.errorPopupMicrophone()
                                    self.hangUpPermissions()

                                }
                                
                            }
                        })
                    } else {
                        DispatchQueue.main.async {
                            self.errorPopupVideo()
                            self.hangUpPermissions()
                        }
                        
                    }
                })
            }
            
        }
    }
    
    func hangUpPermissions(){
        errorPer = true
        if incoming.clientConn{
            rejectCall(dismiss: false)
        }
    }
    
    func errorPopupVideo(){
        let alert = UIAlertController(title: "Error", message: "You need to enable Camera and Microphone permissions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            self.dismiss(animated: true, completion: nil)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
      
    }
    
    func errorPopupMicrophone(){
        let alert = UIAlertController(title: "Error", message: "You need to enable Camera and Microphone permissions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            self.dismiss(animated: true, completion: nil)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setInitialAppereance(){
        guard let isCaller = WebRTCCallManager.sharedInstance.isCaller else{
            return
        }
        if isCaller{
            addCallingViewController()
            setupTimers()
        }
        else{
            addIncomingViewController()
        }
    }
    
    
    func addCallViewController(){
        DispatchQueue.main.async {

        self.addChild(self.videoCall)
        self.videoCall.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerInCallView.addSubview(self.videoCall.view)
        
        NSLayoutConstraint.activate([
            self.videoCall.view.leadingAnchor.constraint(equalTo: self.containerInCallView.leadingAnchor),
            self.videoCall.view.trailingAnchor.constraint(equalTo: self.containerInCallView.trailingAnchor),
            self.videoCall.view.topAnchor.constraint(equalTo: self.containerInCallView.topAnchor),
            self.videoCall.view.bottomAnchor.constraint(equalTo: self.containerInCallView.bottomAnchor)
            ])
        
            self.videoCall.didMove(toParent: self)
        }
    }
    
    func addCallingViewController(){
        DispatchQueue.main.async {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.callingVC  = (storyboard.instantiateViewController(withIdentifier: "CallingViewController") as! CallingViewController)
            
            if self.calleeName != nil{
                self.callingVC.callerName = self.calleeName!
            }
        self.callingVC.delegate = self
        self.addChild(self.callingVC)
        self.callingVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerPreCallView.addSubview(self.callingVC.view)
        
        NSLayoutConstraint.activate([
            self.callingVC.view.leadingAnchor.constraint(equalTo: self.containerPreCallView.leadingAnchor),
            self.callingVC.view.trailingAnchor.constraint(equalTo: self.containerPreCallView.trailingAnchor),
            self.callingVC.view.topAnchor.constraint(equalTo: self.containerPreCallView.topAnchor),
            self.callingVC.view.bottomAnchor.constraint(equalTo: self.containerPreCallView.bottomAnchor)
            ])
        
            self.callingVC.didMove(toParent: self)
        }
    }
    
    func addIncomingViewController(){
        DispatchQueue.main.async {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.incoming  = (storyboard.instantiateViewController(withIdentifier: "IncomingViewController") as! IncomingViewController)
            if let callerName = self.callerName{
                self.incoming.callerName = callerName
            }
            
        self.incoming.delegate = self
            self.addChild(self.incoming)
        self.incoming.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerPreCallView.addSubview(self.incoming.view)
        
        NSLayoutConstraint.activate([
            self.incoming.view.leadingAnchor.constraint(equalTo: self.containerPreCallView.leadingAnchor),
            self.incoming.view.trailingAnchor.constraint(equalTo: self.containerPreCallView.trailingAnchor),
            self.incoming.view.topAnchor.constraint(equalTo: self.containerPreCallView.topAnchor),
            self.incoming.view.bottomAnchor.constraint(equalTo: self.containerPreCallView.bottomAnchor)
            ])
        
            self.incoming.didMove(toParent: self)
            
            
            if !self.isCaller{
                self.checkForPermissions()
            }
            
        }
    }
    
    func setupTimers(){
        cancelTimer = Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(cancelOutgoingCall), userInfo: nil, repeats: false)
    }
    
    @objc func cancelOutgoingCall(){
        // TIMER ESGOTAT
        if WebRTCCallManager.sharedInstance.isCaller == nil{
            return
        }
        
        if WebRTCCallManager.sharedInstance.isCaller!{
            callingVC.cancelOutgoingCall()
            videoCall.disconnect()
        }
        else{
           viewControllerDidFinish()
        }
       
    }
    
    func invalidateTimer() {
        if cancelTimer != nil{
            cancelTimer.invalidate()
        }
    }
    
    func receivedErrorInCall(){
        invalidateTimer()
        DispatchQueue.main.async {
            self.videoCall.disconnect()
            self.videoCall.willMove(toParent: nil)
            self.videoCall.view.removeFromSuperview()
            self.videoCall.removeFromParent()
            if self.callingVC != nil{
                self.callingVC.receivedErrorInCall()
            }
        }
    }
    
    override public var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && (UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown)  {
            return UITraitCollection(traitsFrom:[UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
        }
        return super.traitCollection
    }
}

extension CallContainerViewController: VideoCallViewControllerDelegate{
    func clientConnected() {
        if !WebRTCCallManager.sharedInstance.isCaller!{
          
            incoming.clientConnected()
            
            DispatchQueue.main.async {
                Timer.after(1.seconds) {
                    
                    if self.incoming.labelInfo.text !=  "Connecting"{
                        if WebRTCCallManager.sharedInstance.roomId != nil{
                            if self.errorPer{
                                self.rejectCall(dismiss: false)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func errorInCall() {
        containerPreCallView.isHidden = false

        if WebRTCCallManager.sharedInstance.isCaller!{
            invalidateTimer()
            DispatchQueue.main.async {
                self.videoCall.disconnect()
                self.videoCall.willMove(toParent: nil)
                self.videoCall.view.removeFromSuperview()
                self.videoCall.removeFromParent()
                self.callingVC.receivedErrorDuringCall()
            }
            
        }
        else{
            invalidateTimer()
            DispatchQueue.main.async {
                self.videoCall.callRejected = true
                self.videoCall.mustShowError = true
                self.videoCall.disconnect()
                self.videoCall.willMove(toParent: nil)
                self.videoCall.view.removeFromSuperview()
                self.videoCall.removeFromParent()

                self.incoming.receivedErrorDuringCall()
            }
        }
    }
    

    func errorBeforeConnecting() {
        if WebRTCCallManager.sharedInstance.isCaller!{
            invalidateTimer()
            DispatchQueue.main.async {
                self.videoCall.disconnect()
                self.videoCall.willMove(toParent: nil)
                self.videoCall.view.removeFromSuperview()
                self.videoCall.removeFromParent()
                self.callingVC.receivedErrorInCall()
            }
         
        }
        else{
            invalidateTimer()
            DispatchQueue.main.async {
                self.videoCall.callRejected = true
                self.videoCall.mustShowError = true
                self.videoCall.disconnect()
                self.videoCall.willMove(toParent: nil)
                self.videoCall.view.removeFromSuperview()
                self.videoCall.removeFromParent()
                self.incoming.receivedErrorInCall()
            }
        }
    }
    
    func viewControllerDidFinish() {
        if !errorPer{
            if !self.isBeingDismissed{
                self.dismiss(animated: true, completion: {
                })
            }
        }
       
    }
    
    func receivedCompleted() {
        invalidateTimer()
        containerPreCallView.isHidden = true
    }
    
    func weWereAlone() {
        DispatchQueue.main.async {
            self.invalidateTimer()
            self.rejectCall(dismiss: true)
        }
    }
    
    func calleeRejectedCall() {
        if WebRTCCallManager.sharedInstance.isCaller!{
            DispatchQueue.main.async {
                self.videoCall.willMove(toParent: nil)
                self.videoCall.view.removeFromSuperview()
                self.videoCall.removeFromParent()
                self.invalidateTimer()
                self.callingVC.calleeRejectedCal()
            }
        }
    }
}

extension CallContainerViewController: CallingViewControllerDelegate{
    func cancelCall() {
        videoCall.hangUp(dismiss: true)
        videoCall.willMove(toParent: nil)
        videoCall.view.removeFromSuperview()
        videoCall.removeFromParent()

    }
    
    func retryCall() {
        if let userId = WebRTCCallManager.sharedInstance.calleeId{
            videoCall = VideoCallViewController(roomId: self.roomId!, calleeId: userId, delegate: self)
            addCallViewController()
            
            setupTimers()
            callingVC.retryCall()
        }
    }

}

extension CallContainerViewController: IncomingViewControllerDelegate{
    func acceptCall() {
        videoCall.calleeStartCall()
        addCallViewController()
    }
    
    func rejectCall(dismiss: Bool) {
        
        videoCall.rejectedCall()
        videoCall.hangUp(dismiss: dismiss)
        invalidateTimer()

        if dismiss{
            self.dismiss(animated: true, completion: nil)
        }
    }

}
