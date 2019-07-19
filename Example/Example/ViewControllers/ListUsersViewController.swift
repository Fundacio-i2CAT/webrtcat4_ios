//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit
import SlideMenuControllerSwift
import SwiftyJSON
import AVFoundation
import Alamofire

class ListUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var userContactList: UITableView!
    @IBOutlet weak var call: UIButton!
    
    var isCaller = false
    
    var arrayAgendaUsers:NSMutableArray = NSMutableArray()
    var callMusic : AVAudioPlayer?
    
    var timer:Timer!
    let timeInterval:TimeInterval = 0.05
    var timeCount:TimeInterval = 0.0
    
    override func viewDidLoad() {
        self.title = "WebRTCat list Users"
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
       
        
        getAgendaUsers()
        
    }
   
    func moveToCall(){
        
        self.performSegue(withIdentifier: "callUser", sender: Room.sharedInstance.returnedRoomName)
        
    }
    
    func getAgendaUsers(){
        
        Alamofire.request(WebRTCatRouter.listUsers).responseJSON{ response in
            print (response.result)
            switch response.result{
            case .success(let json):
                switch response.response!.statusCode{
                case 200..<400: //OK
                    let my_resultJSON = JSON(json)
                    print("\(my_resultJSON)")
                    if(my_resultJSON.count != 0){
                        self.processListUsers(json: my_resultJSON);
                    }
                default:
                    print("error")
                }
            case .failure(_):
                print("error")
            }
        }
        
    }
    
    func processListUsers(json:JSON){
        
        let userToken:String = User.sharedInstance.returnedNotifToken
        
        for item in json.arrayValue {
            let _user:UserAgenda = UserAgenda()
            print(item["username"].stringValue)
            let currentToken:String = item["notif_token"].stringValue
            if userToken != currentToken {
                _user.setUserName(username: item["username"].stringValue)
                _user.setNotifToken(notifToken: currentToken)
                _user.setId(id: item["_id"].stringValue)
                arrayAgendaUsers.add(_user)
            }
            
        }
        
        
        
        self.userContactList.reloadData();
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    // Candidate has non-matching type '(UITableView, NSIndexPath) -> UITableViewCell'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UserContactListViewCell = self.userContactList.dequeueReusableCell(withIdentifier: "usercell") as! UserContactListViewCell
        
        let user:UserAgenda = arrayAgendaUsers.object(at: indexPath.row) as! UserAgenda
        
        cell.userContactName.text = user.getUserName()
        cell.userContactImage.image = UIImage(named: "webrtcIcon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAgendaUsers.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user:UserAgenda = arrayAgendaUsers.object(at: indexPath.row) as! UserAgenda
        callUser(user: user)
        
    }
    
    func callUser(user:UserAgenda){
        
        self.performSegue(withIdentifier: "createRoom", sender: user)
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "createRoom"){
            let roomController: RoomNameViewController = segue.destination as! RoomNameViewController
            let data: UserAgenda = sender as! UserAgenda
            roomController.user = data
        }
        
    }
    
    
    
}
extension ListUsersViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
