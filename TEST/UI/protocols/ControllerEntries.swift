//
//  ControllerEntries.swift
//  OneDentity
//
//  Created by Dmitry Khotyanovich on 2/14/18.
//

import UIKit

enum Storyboard: String {
    case main = "Main"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                             function: String = #function,
                                             line: Int = #line,
                                             file: String = #file) -> T {
        let storyboardID = viewControllerClass.storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("""
                ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.
                File: \(file)
                Line Number: \(line)
                Function: \(function)
                """)
        }
        return scene
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiate(from storyboard: Storyboard) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
}
