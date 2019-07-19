//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON

class LoginWebRTCViewController: UIViewController ,UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var goToRegisterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkRegister();
        initView()
        
        // Do any additional setup after loading the view.
    }
    
    func checkRegister(){
        let defaults = UserDefaults.standard

        if let name = defaults.string(forKey: USER_KEY){
            goToMainView(userName: name)
        }
    }
    
    func initView(){
        userName.delegate = self
        password.delegate = self
        loginButton.layer.cornerRadius = 10; // this value vary as per your desire
        loginButton.clipsToBounds = true;
        
        goToRegisterButton?.layer.cornerRadius = 10; // this value vary as per your desire
        goToRegisterButton?.clipsToBounds = true;
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//        appDelegate.setTokenFirebaseCloudMessaging()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func goToRegisterViewAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerView", sender: nil)
    }
    
    @IBAction func loginButton(_ sender: UIButton!) {
        if let userNameValue: String = userName.text!{
            if !userNameValue.isEmpty{
                var userExists = false
                Alamofire.request(WebRTCatRouter.listUsers).responseJSON{ response in
                    print (response.result)
                    switch response.result{
                    case .success(let json):
                        switch response.response!.statusCode{
                        case 200..<400: //OK
                            let my_resultJSON = JSON(json)
                            for item in my_resultJSON.arrayValue {
                                if item["username"].stringValue == userNameValue{
                                    userExists = true
                                    
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let token:String = appDelegate.getTokenFirebaseCloudMessaging()
                                    let parameters = [
                                        "notif_token": token,
                                        "username":userNameValue
                                    ]

                                    Alamofire.request(WebRTCatRouter.register(parameters)).responseJSON{ response in
                                        print (response.result)
                                        print (response.request?.urlRequest)
                                        
                                        switch response.result{
                                        case .success(let json) :
                                            switch response.response!.statusCode{
                                            case 200..<400: //OK
                                                let my_resultJSON = JSON(json)
                                                print("\(my_resultJSON)")
                                                if(my_resultJSON.count != 0){
                                                    
                                                    if(my_resultJSON["error"] != JSON.null){
                                                        let alert = UIAlertController(title: "Error", message: my_resultJSON["error"].stringValue, preferredStyle: UIAlertController.Style.alert)
                                                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                                                        self.present(alert, animated: true, completion: nil)
                                                        //self.showAlertWithMessage(my_resultJSON["error"].stringValue)
                                                    }else{
                                                        //correct, go to login view
                                                        self.goToMainView(userName: userNameValue)
                                                        return
                                                        
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
                            }
                            
                            if !userExists{
                                self.showAlertWithMessage(message: "username don't exists")
                            }

                            
                            
                        default:
                            print("error")
                        }
                    case .failure(_):
                        print("error")
                    }
                }
                
               
                
            }else{
                showAlertWithMessage(message: "username cannot be left blank")
            }
        }else{
            showAlertWithMessage(message: "Enter the username")
        }
        
    }
    
    
    
    func showAlertWithMessage(message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func goToMainView(userName: String){
        
        let defaults = UserDefaults.standard
        defaults.set(userName, forKey: USER_KEY)
        User.sharedInstance.returnedUserName = userName

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createMenuView()
        
    }
    
    
    
    
}

