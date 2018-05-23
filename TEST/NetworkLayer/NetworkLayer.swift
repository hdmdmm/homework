//
//  NetworkLayer.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/21/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import Foundation
import Moya
import RxSwift

//class AuthPlugin: PluginType {
//    var token: String?
//    init(_ token: String? = nil) {
//        self.token = token
//    }
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        guard let token = token else {
//            return request
//        }
//        var request = request
//        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        return request
//    }
//}

final class NetworkLayer {
    private let provider: MoyaProvider<API>
    private var disposeBag =  DisposeBag()
//    private let tokenPlugin: AuthPlugin

    init() {
//        self.tokenPlugin = AuthPlugin()
        provider = MoyaProvider<API>()//(plugins: [tokenPlugin])
    }
    
    func users( completion: @escaping ((Set<UserModel>?, Error?) -> Swift.Void)) {
        provider.request(.list) { result in
            switch result {
            case .success(let response):
                do {
                    let models: Set<UserModel>? = try self.mapData(data: response.data, dataKey: "data")
                    completion(models, nil)
                }
                catch (let error) {
                    completion(nil, error)
                }
                break

            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    func vehicleLocations( userid: Int?, completion: @escaping ((Set<GeoParams>?, Error?) -> Swift.Void)) {
        guard let userid = userid else {
            log.error("Wrong input parameter userid")
            completion(nil, NetworkLayerErrors.invalidArgument.error)
            return
        }

        provider.request(.location(userid: userid)) { result in
            switch result {
            case .success(let response):
                do {
                    let models: Set<GeoParams>? = try self.mapData(data: response.data, dataKey: "data")
                    print(models ?? "")
                    completion(models, nil)
                }
                catch (let error) {
                    completion(nil, error)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    private func mapData<T>(data: Data, dataKey: String) throws -> Set<T>? where T: Codable {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = json as? [String: Any],
            let data = dictionary[dataKey] as? [[String: Any]] else {
            throw NetworkLayerErrors.json.error
        }
        let filtered = data.compactMap({ $0.isEmpty ? nil: $0})
        guard let jsonData = try? JSONSerialization.data(withJSONObject: filtered, options: []) else {
            throw NetworkLayerErrors.json.error
        }
        return try? JSONDecoder().decode(Set<T>.self, from: jsonData)
    }
}
