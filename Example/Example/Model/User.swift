//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation

class User {
    
    var userName : String = ""
    var _id : String = ""
    var notifToken = ""
    
    class var sharedInstance : User {
        struct Static {
            static let instance : User = User()
        }
        return Static.instance
    }
    
    var returnedUserName : String {
        get{
            return self.userName
        }
        
        set {
            self.userName = newValue
        }
    }
    
    var returnedId : String {
        get{
            return self._id
        }
        
        set {
            self._id = newValue
        }
    }
    var returnedNotifToken : String {
        get{
            return self.notifToken
        }
        
        set {
            self.notifToken = newValue
        }
    }
}
