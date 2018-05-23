//
//  UIColor+fromHexString.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) {
        self.init(red: CGFloat(red)/255,
                  green: CGFloat(green)/255,
                  blue: CGFloat(blue)/255,
                  alpha: CGFloat(alpha)/255)
    }
    
    convenience init?(fromHex: String?) {
        guard let hex = fromHex else { return nil }
        var rgbaValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        guard scanner.scanHexInt32(&rgbaValue) else {
            return nil
        }
        self.init(Int((rgbaValue & 0xFF000000) >> 24),
                  Int((rgbaValue & 0xFF0000) >> 16),
                  Int((rgbaValue & 0xFF00) >> 8),
                  Int(rgbaValue & 0xFF))
    }
}
