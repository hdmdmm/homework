//
//  LocalizedStrings.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

struct LocalizedStrings {
    struct Application {
        static let error = NSLocalizedString("app_error", comment: "Alert title")
        static let okey = NSLocalizedString("app_ok", comment: "Alert button")
        static let cancel = NSLocalizedString("app_cancel", comment: "")
    }

    struct Errors {
        static let generalError = NSLocalizedString("msg_error_generic", comment: "Network Layer Errors")
        static let argumentError = NSLocalizedString("msg_error_argument", comment: "Network Layer Errors")
        static let wrongJSONError = NSLocalizedString("msg_error_json", comment: "Network Layer Errors")
        static let geocodingError = NSLocalizedString("msg_error_geocoding", comment: "Geo Layer Errors")
    }
    struct Titles {
        static let error = NSLocalizedString("app_error", comment: "Alert title")
        static let okey = NSLocalizedString("app_ok", comment: "Alert button")
    }
}
