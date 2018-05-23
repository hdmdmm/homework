//
//  CarAnnotationView.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import MapKit

class CarAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let carAnnotation = newValue as? CarAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero,
                                                      size: CGSize(width: 50, height: 50)))
            imageView.contentMode = .scaleAspectFit
            imageView.load(by: carAnnotation.vehicleModel.imgUrl)
            leftCalloutAccessoryView = imageView
            
            image = UIImage(named: carAnnotation.pinImageName)?.withRenderingMode(.alwaysTemplate)
            
            let detailLabel = UILabel(frame: <#T##CGRect#>)
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(14)
            detailLabel.text = carAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
            carAnnotation.requestForGeoCoding {[detailLabel] address in
                DispatchQueue.main.async { [weak self] in
                    detailLabel.text = address
                    self?.setNeedsLayout()
                }
            }

            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)))
            let attTitle = NSAttributedString(string: "Route", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)])
            button.setAttributedTitle(attTitle, for: .normal)
            button.backgroundColor = UIColor(fromHex: carAnnotation.vehicleModel.color)
            rightCalloutAccessoryView = button
        }
    }
}

extension UILabel {
    
}
