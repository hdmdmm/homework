//
//  NetworkLayerErrors.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

enum NetworkLayerErrors: Error {
    case general, invalidArgument, json
    var error: NSError {   
        switch self {
        case .general:
            return error(-2000, LocalizedStrings.Errors.generalError)
        case .invalidArgument:
            return error(-2001, LocalizedStrings.Errors.argumentError)
        case .json:
            return error(-2002, LocalizedStrings.Errors.wrongJSONError)
        }
    }
}

extension Error {
    func error(_ code: Int, _ text: String) -> NSError {
        return NSError(domain: Domain.name(with: #file),
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: text])
    }
}

