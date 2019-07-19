//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import Foundation
import Alamofire

class ApiClient {
    static let sharedInstance = ApiClient()
    
    let defaultApiClient: Alamofire.SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration:configuration,
            serverTrustPolicyManager: nil
        )
    }()
}
