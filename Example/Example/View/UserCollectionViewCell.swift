//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
