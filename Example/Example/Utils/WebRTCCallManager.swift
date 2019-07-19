//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import Foundation
import AVFoundation

class WebRTCCallManager: NSObject, URLSessionDelegate{
    
    static let sharedInstance = WebRTCCallManager()

    var roomId: String?
    var callerId: String?
    var calleeId: String?
    var isCaller: Bool?
    
    
}

