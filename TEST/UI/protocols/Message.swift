//
//  UIViewController+Error.swift
//  OneDentity
//
//  Created by Dmitry Khotyanovich on 2/19/18.
//

import Foundation
import UIKit

protocol Message {
}

typealias Action = () -> Swift.Void
extension Message where Self: UIViewController {

    func showError(_ error: Error?, action: Action? = nil) {
		let alert = UIAlertController(title: LocalizedStrings.Application.error, message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: LocalizedStrings.Application.okey, style: .default, handler: { _ in
                action?()
            })
        )
		present(alert, animated: true, completion: nil)
	}

    func showMessage(_ title: String?, _ message: String?, okey: Action?, cancel: Action?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: LocalizedStrings.Application.okey, style: .default, handler: {_ in
                okey?()
            }))
        if cancel != nil {
            alert.addAction(
                UIAlertAction(title: LocalizedStrings.Application.cancel, style: .cancel, handler: {_ in
                    cancel?()
                }))
        }
        present(alert, animated: true, completion: nil)
    }
}
