//
//  UserModel.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
struct OwnerModel: Codable {
    var name: String?
    var surname: String?
    var imgUrl: String?
    private enum CodingKeys: String, CodingKey {
        case imgUrl = "foto"
        case name, surname
    }
}

struct VehicleModel: Codable {
    var vehicleID: Int?
    var make: String?
    var model: String?
    var year: String?
    var color: String?
    var vin: String?
    var imgUrl: String?
    private enum CodingKeys: String, CodingKey {
        case vehicleID = "vehicleid"
        case imgUrl = "foto"
        case make, model, year, color, vin
    }
}

struct UserModel: Codable, Hashable {
    var userID: Int?
    var owner: OwnerModel?
    var vehicles: [VehicleModel]?

    private enum CodingKeys: String, CodingKey {
        case userID = "userid"
        case owner, vehicles
    }

    var hashValue: Int {
        guard let hashValue = userID?.hashValue else {
            log.error("Returned wrong hash value. userID value not initialized")
            return -1
        }
        return hashValue
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.userID == rhs.userID
    }
}

struct GeoParams: Codable, Hashable {
    var vehicleid: Int?
    var lat: Double?
    var lon: Double?

    var hashValue: Int {
        return vehicleid?.hashValue ?? 0
    }

    static func == (lhs: GeoParams, rhs: GeoParams) -> Bool {
        return lhs.vehicleid == rhs.vehicleid
    }
}

