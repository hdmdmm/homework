//
//  DataLayer.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit

class DataLayer {
//    var listData: Data?
    private var userData = Set<UserModel>()
    private var geoposition = Set<GeoParams>()
    private var networkLayer = NetworkLayer()

    func getList(_ completion: (([UserModel]?, Error?) -> Swift.Void)? ) -> [UserModel]? {
        if let completion = completion {
            networkLayer.users { models, error in
                guard let models = models else {
                    completion(nil, error)
                    return
                }
                completion([UserModel](models), error)
            }
        }
        return [UserModel](userData)
    }
    
    func geoposition(of userID: Int?,
                     completion: ((Set<GeoParams>?, Error?) -> Swift.Void)? ) -> Set<GeoParams>? {

        if let completion = completion {
            networkLayer.vehicleLocations(userid: userID) { newGeoParams, error in
                completion(newGeoParams, error)
            }
        }
        return geoposition
    }
}

