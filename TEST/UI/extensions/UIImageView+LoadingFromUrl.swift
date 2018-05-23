//
//  UIImageView+LoadingFromUrl.swift
//  ChatBot
//
//  Created by Dmitry Khotyanovich on 12/1/17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import UIKit

/// The extenstion of UIImageView to load images by url at initializing content
extension UIImageView {
    
    /// Loading of images by url. For the fast dev. practice was used Data(conentsOf: url) to get
    /// image content.
    /// Parameters:
    /// urlString as String type
    func load(by urlString: String? ) {
        self.image = nil
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
            NSLog("The input parameter url is not valid")
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
                NSLog("The loading of image was not successful")
                return
            }
            DispatchQueue.main.async {
                self?.image = image
                self?.setNeedsDisplay()
            }
        }
    }
}
