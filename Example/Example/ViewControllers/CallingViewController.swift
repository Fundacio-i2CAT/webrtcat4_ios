//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit

protocol CallingViewControllerDelegate: AnyObject {
    func cancelCall()
    func retryCall()

}


class CallingViewController: UIViewController {
    
    weak var delegate:CallingViewControllerDelegate?

    @IBOutlet weak var penjarButton: UIButton!
    @IBOutlet weak var outgoingView: UIView!

    @IBOutlet weak var labelInfo: UILabel!

    var callerId = ""
    var roomid = ""
    var callerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
       
        labelInfo.text = "Calling \(callerName)"
    }
    
    func retryCall(){
        
    }
    
    func setupUI(){
        penjarButton.setTitle("End call", for: .normal)
    }
    
 
    @IBAction func cancelCall(_ sender: Any) {
        delegate?.cancelCall()
        
        self.dismiss(animated: true) {
         
        }
    }
    
    
    func cancelOutgoingCall(){
        outgoingView.isHidden = true

    }
    
    func receivedErrorInCall(){
        self.dismiss(animated: true) {
                let alert = UIAlertController(title: "Error", message: "Call cannot be established", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  }))
                self.present(alert, animated: true, completion: nil)
        }

    }
    
    func receivedErrorDuringCall(){
        self.dismiss(animated: true) {
                let alert = UIAlertController(title: "Error", message: "Error in call", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
        }
        
    }

 
   
    func calleeRejectedCal(){
        
        let alert = UIAlertController(title: "Error", message: "Call cannot be established", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)

      
    }
    
}
