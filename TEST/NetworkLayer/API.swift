//
//  userListEndpoint.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import Moya

enum API {
    case list
    case location(userid: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return AppConstants.hostApiUrl
    }
    
    var path: String {
        return "api/"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any] {
        switch self {
        case .list:
            return ["op": "list"]
        case .location(let userid):
            return ["op": "getlocations",
                    "userid": userid]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
}

