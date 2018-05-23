//
//  GeoLayer.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/23/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLayer {
    private let geocoding = CLGeocoder()
    func getLocationAddress(location: CLLocation,
                            completion: @escaping (_ adderss: String?, _ error: Error?) -> Swift.Void ) {
        geocoding.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                log.warning("Geocoding of \(location) was not success")
                completion(nil, error)
                return
            }
            guard let placemarks = placemarks,
                !placemarks.isEmpty,
                let placemark = placemarks.first  else {
                    log.warning("Geocoding didn't recognise location!!! :(")
                    completion(nil, GeoLayerErrors.general.error)
                    return
            }
            var addressString : String = ""
            if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
                if placemark.country != nil {
                    addressString = placemark.country ?? ""
                }
                if placemark.subAdministrativeArea != nil {
                    addressString = addressString + (placemark.subAdministrativeArea ?? "") + ", "
                }
                if placemark.postalCode != nil {
                    addressString = addressString + (placemark.postalCode ?? "") + " "
                }
                if placemark.locality != nil {
                    addressString = addressString + (placemark.locality ?? "")
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + (placemark.thoroughfare ?? "")
                }
                if placemark.subThoroughfare != nil {
                    addressString = addressString + (placemark.subThoroughfare ?? "")
                }
            } else {
                if placemark.subThoroughfare != nil {
                    addressString = (placemark.subThoroughfare ?? "") + " "
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + (placemark.thoroughfare ?? "") + ", "
                }
                if placemark.postalCode != nil {
                    addressString = addressString + (placemark.postalCode ?? "") + " "
                }
                if placemark.locality != nil {
                    addressString = addressString + (placemark.locality ?? "") + ", "
                }
                if placemark.administrativeArea != nil {
                    addressString = addressString + (placemark.administrativeArea ?? "") + " "
                }
                if placemark.country != nil {
                    addressString = addressString + (placemark.country ?? "")
                }
            }
            completion(addressString, nil)
        }
    }
}
