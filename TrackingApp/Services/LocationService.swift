//
//  LocationService.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import CoreLocation
import FirebaseFirestore

final class LocationService: NSObject, CLLocationManagerDelegate {

    static let shared = LocationService()

    private let locationManager = CLLocationManager()
    
    var routeId: String? = nil
    private(set) var isTracking = false

    override init() {
        super.init()
        
        print("Configuring Location Service...")

        locationManager.delegate = self

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.distanceFilter = 10
        //locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        print("Location Service Configured!")
    }

    func startTracking(forRouteId routeId: String) {
        self.routeId = routeId
        
        guard !isTracking else { return }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        isTracking = true
        
        print("Location Tracking Started!")
    }

    func stopTracking() {
        guard isTracking else { return }
        
        locationManager.stopUpdatingLocation()
        
        isTracking = false
        self.routeId = nil
        
        print("Location Tracking Stoped!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        print(latitude, longitude)

        if routeId != nil {
            Task {
                do {
                    let db = Firestore.firestore()
                    
                    let coordinate = Coordinate(routeId: routeId!, latitude: latitude, longitude: longitude, timestamp: Date().millisecondsSince1970)
                    
                    try db.collection("Coordinates").addDocument(from: coordinate)
                } catch {
                    print("Error creating document: \(error)")
                }
            }
        }
    }
}
