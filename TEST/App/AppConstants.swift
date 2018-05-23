//
//  AppConstants.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

struct AppConstants {
    static var hostApiUrl: URL {
        guard let url = URL(string: "http://mobi.connectedcar360.net/") else {
            log.error("The application will not working without api url")
            fatalError("API URL is not valid")
        }
        return url
    }
}

struct Domain {
    fileprivate static let formatter = "com.ocsico.scope.test.%s"
    
    static func name(with moduleName: String) -> String {
        return .init(format: Domain.formatter, moduleName)
    }
}
