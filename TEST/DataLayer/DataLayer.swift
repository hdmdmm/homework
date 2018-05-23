//
//  DataLayer.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RealmSwift

class DataLayer {
    private var networkLayer = NetworkLayer()

    func getList(_ completion: (([UserModel]?, Error?) -> Swift.Void)? ) -> [UserModel]? {
		var users: [UserModel]?

		let realm = try! Realm()
		let results = realm.objects(UserModel.self)
		if !results.isEmpty {
			users = Array(results)
		}

        if let completion = completion {
            networkLayer.users { models, error in
                guard let models = models else {
                    completion(nil, error)
                    return
                }
				let realm = try! Realm()
				for model in models {
					try! realm.write {
						realm.add(model, update: true)
					}
				}
                completion([UserModel](models), error)
            }
        }
        return users
    }
    
	func geoposition(of userID: Int?, completion: (([GeoParams]?, Error?) -> Swift.Void)?) -> [GeoParams]? {
		var geoposition: [GeoParams]?

		let realm = try! Realm()
		if let user = realm.object(ofType: UserModel.self, forPrimaryKey: userID), !user.vehicles.isEmpty {
			let predicates: [NSPredicate] = user.vehicles.compactMap {
				return NSPredicate(format: "vehicleid = %i", $0.vehicleID)
			}
			let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
			let results = realm.objects(GeoParams.self).filter(compoundPredicate)
			if !results.isEmpty {
				geoposition = Array(results)
			}
		}

        if let completion = completion {
            networkLayer.vehicleLocations(userid: userID) { newGeoParams, error in
				guard let newGeoParams = newGeoParams else {
					return
				}
				let realm = try! Realm()
				for model in newGeoParams {
					try! realm.write {
						realm.add(model, update: true)
					}
				}
                completion(newGeoParams, error)
            }
        }
        return geoposition
    }
}

