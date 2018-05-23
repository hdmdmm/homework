//
//  CarAnnotation.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import RxSwift

class CarAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var vehicleModel: VehicleModel!
    
    private let geoLayer = GeoLayer()
    
    init?(userData: UserModel?, geoParams: GeoParams?) {
        guard let geoParams = geoParams,
			let vehicleModel = userData?.vehicles.first(where: { $0.vehicleID == geoParams.vehicleid } )
        else {
            return nil
        }
        title = vehicleModel.model
        coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0) //trick
        self.geoParams = geoParams
        self.vehicleModel = vehicleModel
    }
    
    var geoParams: GeoParams? {
        didSet {
            guard let geoParams = geoParams else {
                return
            }
			coordinate = CLLocationCoordinate2D(latitude: geoParams.lat, longitude: geoParams.lon)
//            requestForGeoCoding()
        }
    }
    
    var pinImageName: String {
        return "CarPin"
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
//        let addressDict = [CNPostalAddressStreetKey: subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    func requestForGeoCoding(_ completion: ((_ address: String?) -> Void)? = nil) {
        let location = CLLocation(latitude: self.coordinate.latitude,
                                  longitude: self.coordinate.longitude)
        geoLayer.getLocationAddress(location: location) { [weak self] address, error in
            if error != nil {
                log.error(error!)
                return
            }
            self?.subtitle = address
            print(address ?? "")
            completion?(address)
        }
    }
}
