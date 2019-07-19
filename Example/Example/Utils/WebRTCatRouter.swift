//  Webrtcat4 Example
//
//  Copyright © 2019 i2Cat. All rights reserved.

import Foundation
import Alamofire

enum WebRTCatRouter: URLRequestConvertible {
    
    static let baseUrl = URL_BASE;
    
    case listUsers
    case register([String: Any])
    case notifyCallee([String: Any])
    case fetchIncoming(String)
    case login([String: Any])

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .listUsers, .fetchIncoming, .login:
                return .get
            case .register, .notifyCallee:
                return .post
            }
        }
        
        let params:([String: Any]?) = {
            switch self {
            case .register(let params), .login(let params):
                return params
            case .notifyCallee(let params):
                return params
            default:
                return nil
            }
        }()
        
        let url: URL = {
            let relativePath: String?
            switch self {
            case .listUsers:
                relativePath = "users"
            case .fetchIncoming(let id):
                relativePath = "user/\(id)"
            case .register, .login:
                relativePath = "user"
            case .notifyCallee:
                relativePath = "notify"
            }
            
            var url = URL(string: WebRTCatRouter.baseUrl)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
                print(url);
            }
            return url
            
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: params)
        
    }
    
}



