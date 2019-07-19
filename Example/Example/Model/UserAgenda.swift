//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation
class UserAgenda {
    
    var userName : String = ""
    var notifToken : String = ""
    var _id : String = ""
    
    func setUserName(username: String){
        self.userName = username
    }
    
    func getUserName() -> String{
        
        return self.userName
    }
    
    func setNotifToken(notifToken: String){
        self.notifToken = notifToken
    }
    
    func getNotifToken() -> String{
        
        return self.notifToken
    }
    
    func setId(id: String){
        self._id = id
    }
    
    func getId() -> String{
        
        return self._id
    }
    
    
}
