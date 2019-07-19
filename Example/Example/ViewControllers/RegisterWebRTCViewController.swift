//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class RegisterWebRTCViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initView(){
        repeatPasswordTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        nameTextField.delegate = self
        usernameTextField.delegate = self
        registerButton.layer.cornerRadius = 10; // this value vary as per your desire
        registerButton.clipsToBounds = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func registerButton(_ sender: UIButton!) {
        
        if(checkFields()){
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let token:String = appDelegate.getTokenFirebaseCloudMessaging()


            let username:String = usernameTextField.text!

            let parameters = [
                "notif_token": token,
                "username":username
            ]

            print(parameters)
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
                                self.performSegue(withIdentifier: "goToLogin", sender: nil)
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
    
    func checkFields()->Bool{
        
        let isCorrect = true
        return isCorrect;
        
    }
    
    func showAlertWithMessage(message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
}
