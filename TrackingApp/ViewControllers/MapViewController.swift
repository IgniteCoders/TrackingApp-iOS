//
//  MapViewController.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var followUserButton: UIButton!
    
    var isFollowingUser = true
    
    var route: Route!
    
    var coordinates: [Coordinate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        followUserButton.isHidden = true
        self.mapView.userTrackingMode = .follow
        
        fetchCoordinates()
    }
    
    func fetchCoordinates() {
        
        let db = Firestore.firestore()
        db.collection("Coordinates")
            .whereField("routeId", isEqualTo: route.id)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                
                guard let docs = snapshot?.documents else {
                    return
                }
                
                let coordinates = docs.compactMap { doc -> CLLocationCoordinate2D? in
                    
                    let coordinate = try! doc.data(as: Coordinate.self)
                    
                    return CLLocationCoordinate2D(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                }
                
                let polyline = MKPolyline(
                    coordinates: coordinates,
                    count: coordinates.count
                )
                
                self.mapView.addOverlay(polyline)
                
                if self.route.endDate != nil {
                    let padding = UIEdgeInsets(
                        top: 50,
                        left: 50,
                        bottom: 50,
                        right: 50
                    )
                    
                    self.mapView.setVisibleMapRect(
                        polyline.boundingMapRect,
                        edgePadding: padding,
                        animated: true
                    )
                }
            }
    }
    
    @IBAction func beginFollowingUser(_ sender: Any) {
        followUserButton.isHidden = true
        isFollowingUser = true
        mapView.userTrackingMode = .follow
    }
    
    func stopFollowingUser() {
        isFollowingUser = false
        followUserButton.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5

        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode != .follow {
            stopFollowingUser()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
