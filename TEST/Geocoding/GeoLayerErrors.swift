//
//  GeoLayerErrors.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/23/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

enum GeoLayerErrors: Error {
    case general
    var error: NSError {
        switch self {
        case .general:
            return error(-5000, LocalizedStrings.Errors.generalError)
        }
    }
}
