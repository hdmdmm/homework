//
//  UserModel.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import RealmSwift

class OwnerModel: Object, Decodable {
    @objc dynamic var name: String?
    @objc dynamic var surname: String?
    @objc dynamic var imgUrl: String?

	override static func primaryKey() -> String? {
		return "surname"
	}

    private enum CodingKeys: String, CodingKey {
        case imgUrl = "foto"
        case name, surname
    }
}

class VehicleModel: Object, Decodable {
    @objc dynamic var vehicleID: Int = 0
    @objc dynamic var make: String?
    @objc dynamic var model: String?
    @objc dynamic var year: String?
    @objc dynamic var color: String?
    @objc dynamic var vin: String?
    @objc dynamic var imgUrl: String?

	override static func primaryKey() -> String? {
		return "vehicleID"
	}

    private enum CodingKeys: String, CodingKey {
        case vehicleID = "vehicleid"
        case imgUrl = "foto"
        case make, model, year, color, vin
    }
}

class UserModel: Object, Decodable {
    @objc dynamic var userID: Int = 0
	@objc dynamic var owner: OwnerModel?
	var vehicles = List<VehicleModel>()

	override static func primaryKey() -> String? {
		return "userID"
	}

    private enum CodingKeys: String, CodingKey {
        case userID = "userid"
        case owner, vehicles
    }

	required convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
		userID = try container.decode(Int.self, forKey: .userID)
		owner = try container.decode(OwnerModel.self, forKey: .owner)
		let vehiclesArray = try container.decode([VehicleModel].self, forKey: .vehicles)
		vehiclesArray.forEach{ vehicles.append($0) }
	}

//    override var hashValue: Int {
//        guard let hashValue = userID?.hashValue else {
//            log.error("Returned wrong hash value. userID value not initialized")
//            return -1
//        }
//        return hashValue
//    }
//
//    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
//        return lhs.userID == rhs.userID
//    }
}

class GeoParams: Object, Decodable {
    @objc dynamic var vehicleid: Int = 0
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0

	override static func primaryKey() -> String? {
		return "vehicleid"
	}

//    var hashValue: Int {
//        return vehicleid?.hashValue ?? 0
//    }
//
//    static func == (lhs: GeoParams, rhs: GeoParams) -> Bool {
//        return lhs.vehicleid == rhs.vehicleid
//    }
}

