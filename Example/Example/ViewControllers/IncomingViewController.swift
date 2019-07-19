//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit

protocol IncomingViewControllerDelegate: AnyObject {
    func acceptCall()
    func rejectCall(dismiss: Bool)
    
}

class IncomingViewController: UIViewController {
    @IBOutlet weak var emisorIncomingImageView: UIImageView!
    @IBOutlet weak var cancelarButton: UIButton!
    @IBOutlet weak var agafarButton: UIButton!
    @IBOutlet weak var labelInfo: UILabel!

    weak var delegate:IncomingViewControllerDelegate?
var callerName = ""
    
    var clientConn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        labelInfo.text =  "Call from \(callerName)"

    }
    
    func clientConnected(){
        clientConn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    

    func setUI(){
        
        cancelarButton.setTitle("Cancel", for: .normal)
        agafarButton.setTitle("Answer", for: .normal)
        
       
    }
    
    
    @IBAction func acceptCall(_ sender: Any) {
        delegate?.acceptCall()
        labelInfo.text =  "Connecting"
        cancelarButton.isHidden = true
        agafarButton.isHidden = true
    }
    
    @IBAction func rejectCall(_ sender: Any) {
        delegate?.rejectCall(dismiss: true)
    }
    
    func receivedErrorInCall(){
        labelInfo.text =  "Error in call"
        cancelarButton.isHidden = true
        agafarButton.isHidden = true
    }
    
    func receivedErrorDuringCall(){
        labelInfo.text =  "Error in call"
        cancelarButton.isHidden = true
        agafarButton.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
