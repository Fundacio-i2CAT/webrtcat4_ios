//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var userName: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
