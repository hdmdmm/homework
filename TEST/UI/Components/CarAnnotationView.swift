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

            //pin marker
            image = UIImage(named: carAnnotation.pinImageName)?.withRenderingMode(.alwaysTemplate)
            
            leftCalloutAccessoryView = initializeCarImage(carAnnotation)
            detailCalloutAccessoryView = initializeAddressReverseGeocoding(carAnnotation)
            rightCalloutAccessoryView = initializeButtonRoute(carAnnotation)
        }
    }
    
    private func initializeCarImage (_ annotation: CarAnnotation) -> UIView {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero,
        size: CGSize(width: 50, height: 50)))
        imageView.contentMode = .scaleAspectFit
        imageView.load(by: annotation.vehicleModel.imgUrl)
        return imageView
    }
    
    private func initializeButtonRoute (_ annotation: CarAnnotation) -> UIView {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)))
        let attTitle = NSAttributedString(string: "Route", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)])
        button.setAttributedTitle(attTitle, for: .normal)
        button.backgroundColor = UIColor(fromHex: annotation.vehicleModel.color)
        return button
    }
    
    private func initializeAddressReverseGeocoding (_ annotation: CarAnnotation) -> UIView {
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(14)
        detailLabel.text = annotation.subtitle
        
        annotation.requestForGeoCoding {[detailLabel] address in
            DispatchQueue.main.async {
                detailLabel.text = address
                detailLabel.setNeedsLayout()
            }
        }
        return detailLabel
    }
}
