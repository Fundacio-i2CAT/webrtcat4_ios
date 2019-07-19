//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import UIKit
import SwiftyJSON
import Alamofire

class RoomNameViewController: UIViewController,UITextFieldDelegate  {
    @IBOutlet weak var roomName: UITextField!
    
    var user: UserAgenda!
    @IBOutlet weak var createRoomButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initView()
        initRoom()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initRoom()
    }
    func initRoom(){
        
        var roomNameLabel = ""
        
        let miliseconds:Int = Int(NSDate().timeIntervalSince1970)
        roomNameLabel = User.sharedInstance.returnedUserName.lowercased() + user.getUserName().lowercased() + String(miliseconds)
        
        Room.sharedInstance.returnedRoomName = roomNameLabel
        
        roomName.text = roomNameLabel
        userNameLabel.text = user.getUserName()
        
    }
    
    func initView(){
        
        createRoomButton.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        createRoomButton.layer.cornerRadius = 0.5 * createRoomButton.bounds.size.width
        createRoomButton.setImage(UIImage(named:"call"), for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectButton(_ sender: UIButton!) {
        //if(isCaller){
        makeCall()
        /*}else{
         acceptCall()
         }*/
    }
    
    func acceptCall(){
        if let roomNameValue: String = roomName.text!{
            if !roomNameValue.isEmpty{
                self.performSegue(withIdentifier: "connectToRoom", sender: roomNameValue)
            }
        }
    }
    
    func makeCall(){
        
        if let roomNameValue: String = roomName.text!{
            if !roomNameValue.isEmpty{
                                
                
                let parameters = [
                    "notifToken": user.getNotifToken(),
                    "roomName":roomNameValue,
                    "callerName":User.sharedInstance.userName
                ]
                
                
                print(User.sharedInstance.userName)
                print(User.sharedInstance.returnedId)

                print(parameters)
                Alamofire.request(WebRTCatRouter.notifyCallee(parameters)).responseJSON{ response in
                
                    switch response.result{
                    case .success(let json):
                        switch response.response!.statusCode{
                        case 200..<400: //OK
                            let my_resultJSON = JSON(json)
                            print("\(my_resultJSON)")
                            
                        default:
                            print("error")
                        }
                    case .failure(_):
                        print("error")
                    }
                }
           
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let callVC = storyboard.instantiateViewController(withIdentifier: "CallContainerViewController") as! CallContainerViewController
                callVC.isCaller = true
                callVC.calleeId =  user.getId()
                callVC.roomId = roomNameValue
                callVC.calleeName = user.getUserName()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController?.present(callVC, animated: true, completion: nil)
                
                
                
            }else{
                showAlertWithMessage(message: "Room name cannot be left blank")
            }
        }else{
            showAlertWithMessage(message: "Enter the room name")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func showAlertWithMessage(message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
   
    
}
