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

        // request for update new user data
        networkLayer.users { models, error in
            guard let models = models else {
                completion?(nil, error)
                return
            }
            completion?([UserModel](models), error)
            
            //try to save last updated data
            self.saveData(data: models)
        }

        //get cached data
        guard let realm = try? Realm() else {
            log.warning("The Realm DB was not initialized")
            return nil
        }
        let results = realm.objects(UserModel.self)
		if !results.isEmpty {
			users = Array(results)
		}
        return users
    }
    
	func geoposition(of userID: Int?, completion: (([GeoParams]?, Error?) -> Swift.Void)?) -> [GeoParams]? {
		var geoposition: [GeoParams]?

        //request for updated geo location of vehicles
        networkLayer.vehicleLocations(userid: userID) { newGeoParams, error in
            guard let newGeoParams = newGeoParams else {
                completion?(nil, error)
                return
            }
            completion?(newGeoParams, error)
            //try to save last updated data
            self.saveData(data: newGeoParams)
        }
        
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
        return geoposition
    }
    
    private func saveData<T>(data: [T]) where T: Object {
        guard let realm = try? Realm() else  {
            log.warning("DB was not initialized")
            return
        }
        data.forEach{ model in
            do {
                try realm.write {
                    realm.add(model, update: true)
                }
            } catch( let error) {
                log.error("Realm throws error at writing user model. Error: \(error)")
            }
        }
    }
}

