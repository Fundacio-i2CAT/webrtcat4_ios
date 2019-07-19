//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation

class Room {
    
    var roomName : String = ""
    var fromWho: String = ""
    
    class var sharedInstance : Room {
        struct Static {
            static let instance : Room = Room()
        }
        return Static.instance
    }
    
    var returnedRoomName : String {
        get{
            return self.roomName
        }
        
        set {
            self.roomName = newValue
        }
    }
    
    var returnedFromWho : String {
        get{
            return self.fromWho
        }
        
        set {
            self.fromWho = newValue
        }
    }
}
