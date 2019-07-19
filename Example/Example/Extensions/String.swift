//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import Foundation

extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        // JMA: OJI
        return String(describing: String(describing: aClass).split(separator: ".").last)
    }
    
    func substring(from: Int) -> String {
        let idx = self.index(self.startIndex, offsetBy: from)
        return String(self[idx...])
    }
    
    var length: Int {
        return self.count
    }
    
}
