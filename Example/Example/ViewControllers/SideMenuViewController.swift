//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import UIKit

enum LeftMenu: Int {
    case ListUsers = 0
    case About
    case Logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class SideMenuViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Contacts", "About", "Logout"]
    var listUsersViewController: UIViewController!
    var aboutViewController: UIViewController!
    
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listUsersViewController = storyboard.instantiateViewController(withIdentifier: "ListUsersViewController") as! ListUsersViewController
        self.listUsersViewController = UINavigationController(rootViewController: listUsersViewController)
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        self.tableView.registerCellClass(cellClass: BaseTableViewCell.self)
        self.imageHeaderView = ImageHeaderView.instanceFromNib() as! ImageHeaderView
        self.imageHeaderView.userName.text = User.sharedInstance.userName
        self.view.addSubview(self.imageHeaderView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .ListUsers:
            self.slideMenuController()?.changeMainViewController(self.listUsersViewController, close: true)
        case .About:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        case .Logout:
            print("logout go to login page")
            /**clear data NSUsers**/
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: USER_KEY)
            self.performSegue(withIdentifier: "logout", sender: nil)
        }
    }
}

extension SideMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .ListUsers, .About, .Logout:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension SideMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .ListUsers, .About, .Logout:
                let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(data: menus[indexPath.row])
                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu: menu)
        }

    }
}

extension SideMenuViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
