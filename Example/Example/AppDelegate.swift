//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit
import SlideMenuControllerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Alamofire
import SwiftyJSON
import webrtcat4
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var showingCallVC: CallContainerViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true

        RTCPeerConnectionFactory.init()
        registerForPushNotifications()

        return true
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
  
    @objc func tokenRefreshNotification(notification: NSNotification) {
        
        setTokenFirebaseCloudMessaging()
        
        connectToFcm()
        
    }
    
    func connectToFcm() {
        // TODO
        /*
         Messaging.messaging().connect { (error) in
         if (error != nil) {
         print("Unable to connect with FCM. \(error)")
         } else {
         print("Connected to FCM.")
         }
         }
         */
    }
    
    func getTokenFirebaseCloudMessaging() -> String{
        if (User.sharedInstance.returnedNotifToken != ""){
            return User.sharedInstance.returnedNotifToken
        }
        return ""
    }
    
    
    func setTokenFirebaseCloudMessaging(){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                User.sharedInstance.returnedNotifToken = result.token

                print("Remote instance ID token: \(result.token)")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        
        setTokenFirebaseCloudMessaging()
        
        connectToFcm()
    }

    
    
    func createMenuView(){
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "ListUsersViewController") as! ListUsersViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "F9AD1D")
        
        
        leftViewController.listUsersViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
       
        
    }
    
    func goCall(roomId:String, callerId:String){
      
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let callVC = storyboard.instantiateViewController(withIdentifier: "CallContainerViewController") as! CallContainerViewController
        callVC.isCaller = false
        callVC.callerId = callerId
        callVC.roomId = roomId
        
        if callerId == "Web"{
            callVC.callerName = "Web"
            
            if (self.showingCallVC != nil){
                DispatchQueue.main.async {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    self.showingCallVC?.dismiss(animated: false, completion: {
                        
                        self.window?.rootViewController?.present(callVC, animated: true, completion: nil)
                        
                        
                    })
                }
                
            }
            else{
                self.window?.rootViewController?.present(callVC, animated: true, completion: nil)
                
            }
            return
        }
        
        Alamofire.request(WebRTCatRouter.listUsers).responseJSON{ response in
            print (response.result)
            switch response.result{
            case .success(let json):
                switch response.response!.statusCode{
                case 200..<400: //OK
                    let my_resultJSON = JSON(json)
                    
                    for item in my_resultJSON.arrayValue {
                        if item["username"].stringValue == callerId{
                            print(item["username"].stringValue)
                            callVC.callerName = item["username"].stringValue

                            if (self.showingCallVC != nil){
                                DispatchQueue.main.async {
                                    UIApplication.shared.beginIgnoringInteractionEvents()
                                    
                                    self.showingCallVC?.dismiss(animated: false, completion: {
                                        
                                        self.window?.rootViewController?.present(callVC, animated: true, completion: nil)
                                        
                                        
                                    })
                                }
                                
                            }
                            else{
                                self.window?.rootViewController?.present(callVC, animated: true, completion: nil)
                                
                            }
                            
                        
                        }
                      
                    }

                default:
                    print("error")
                }
            case .failure(_):
                print("error")
            }
        }
        
        
      
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    //    Messaging.messaging().shouldEstablishDirectChannel = false
    //    print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        application.applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("bbb")

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("PUSH RECEIVED")
        print(userInfo)
        
        if(Utils().isLogged()){
            if let type = userInfo["type"] as? String{
                
                switch type {
                case INCOMING_CALL:
                    let roomId = userInfo["roomName"] as! String
                    var callerId = ""
                    if((userInfo["callerName"]) != nil){
                        callerId = userInfo["callerName"] as! String
                        let systemSoundID: SystemSoundID = 1015
                        
                        // to play sound
                        AudioServicesPlaySystemSound (systemSoundID)
                        Timer.after(0.5.seconds) {
                            self.goCall(roomId: roomId , callerId: callerId as String)

                        }
                    }
                    else{
                        callerId = "Web"
                        let systemSoundID: SystemSoundID = 1015
                        
                        // to play sound
                        AudioServicesPlaySystemSound (systemSoundID)
                        Timer.after(0.5.seconds) {
                            self.goCall(roomId: roomId , callerId: callerId as String)
                            
                        }
                    }
                    
                default:
                    break
                }
            }
            
        }
        
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
     
    }
    
    
}

