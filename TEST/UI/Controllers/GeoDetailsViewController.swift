//
//  GeoDetailsViewController.swift
//  TEST
//
//  Created by Dmitry Khotyanovich on 5/22/18.
//  Copyright © 2018 OCSICO. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxMKMapView
import RxSwift
import RxCocoa

class GeoDetailsViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var userModel: UserModel?
    
    private let annotations = BehaviorRelay<Set<CarAnnotation>>(value: [])
    private let dataLayer = DataLayer()
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLocationManager()
        setupMapView()
        setupCarGeolocationUpdater()
        udpateVehicleGeolocation()
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.register(CarAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CarAnnotationView")
    }

//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            locationManager.requestLocation()
//        }
//    }
    
    private func setupCarGeolocationUpdater() {
        Observable<Int>.interval(30, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.udpateVehicleGeolocation()
            }
            .disposed(by: disposeBag)
    }

    private func udpateVehicleGeolocation() {
        let completion: ([GeoParams]?, Error?) -> Swift.Void = { [weak self] params, error in
            if error != nil {
                self?.showError(error)
                return
            }
            guard let params = params else {
                log.warning("Remote service returns nothing")
                return
            }
            self?.updateMarkersOnMap(params)
        }
        
        guard let params = dataLayer.geoposition(of: userModel?.userID, completion: completion),
            !params.isEmpty else {
            log.warning("didn't find cached parameters")
            return
        }
        self.updateMarkersOnMap(params)
    }

    private func updateMarkersOnMap(_ params: [GeoParams]) {
//        DispatchQueue.main.async { [unowned self] in
//            self.mapView.removeAnnotations(self.mapView.annotations)
//            self.mapView.addAnnotations(params.compactMap {
//                CarAnnotation(userData: self.userModel, geoParams: $0)
//            })
//            let center = self.mapView.centerCoordinate
//            self.mapView.centerCoordinate = center
//        }
        //add markers if empty
        if annotations.value.isEmpty {
            let fromNewParams = Set<CarAnnotation> (params.compactMap {
                CarAnnotation(userData: userModel, geoParams: $0)
            })
            annotations.accept(fromNewParams)
            mapView.addAnnotations([CarAnnotation](fromNewParams))
            return
        }

        //update parameters in annotations
        DispatchQueue.main.async {
            self.annotations.value.forEach { annotation in
                guard let geoParams = params.first(where: { $0.vehicleid == annotation.vehicleModel.vehicleID }) else {
                    return
                }
//                annotation.geoParams = geoParams
                if annotation.coordinate == CLLocationCoordinate2D(latitude: geoParams.lat, longitude: geoParams.lon) {
                    print("the coordinates where not changed.")
                    return
                }
                annotation.coordinate = CLLocationCoordinate2D(latitude: geoParams.lat, longitude: geoParams.lon)
                self.mapView.view(for: annotation)?.annotation = annotation

                //tricky way to update markers on map.
                let center = self.mapView.centerCoordinate
                self.mapView.centerCoordinate = center
            }
        }
        
//        DispatchQueue.main.async {
//            self.mapView.showAnnotations([CarAnnotation](self.annotations.value), animated: true)
//        }
        
        //do merge
//        let toAdd = fromNewParams.intersection(annotations.value)
//        if !toAdd.isEmpty {
//            mapView.addAnnotations([CarAnnotation](toAdd))
//        }
//        let toRemove = annotations.value.subtracting(fromNewParams)
//        if !toRemove.isEmpty {
//            mapView.removeAnnotations([CarAnnotation](toRemove))
//        }
    }
    
    private func requestForDirection(_ annotation: CarAnnotation) {
        // prepare for dirction request
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = annotation.mapItem()
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { response, error in
            if error != nil {
                print("Error getting directions")
            }
            guard let response = response else { return }
            self.showRoute(response)
        })
    }
    
    private func showRoute(_ response: MKDirectionsResponse) {
        response.routes.forEach { route in
            mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
}

extension GeoDetailsViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let id = "CarAnnotationView"
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) else {
            return CarAnnotationView(annotation: annotation, reuseIdentifier: id)
        }
        view.annotation = annotation
        return view
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotationView = view as? CarAnnotationView,
            let annotation = annotationView.annotation as? CarAnnotation else { return }
        requestForDirection(annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}

//extension GeoDetailsViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//        mapView.setCenter(location.coordinate, animated: true)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}

extension GeoDetailsViewController: Message {}

extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        return self.latitude.hashValue ^ self.longitude.hashValue
    }
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
    
}
