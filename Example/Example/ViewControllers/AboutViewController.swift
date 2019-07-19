//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.


import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        self.title = "About WebRTCat"
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    

}
