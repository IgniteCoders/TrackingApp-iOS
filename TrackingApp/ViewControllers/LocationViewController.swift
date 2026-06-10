//
//  RoutesViewController.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LocationViewController: UIViewController {
    
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var stopTrackingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        refreshButtonsStatus()
        findActiveRoute()
    }
    
    func findActiveRoute() {
        let userId = Auth.auth().currentUser!.uid
        
        Task {
            do {
                let db = Firestore.firestore()
                let querySnapshot = try await db.collection("Routes")
                    .whereField("userId", isEqualTo: userId)
                    .whereField("endDate", isEqualTo: -1)
                    .limit(to: 1)
                    .getDocuments()
                
                guard let document = querySnapshot.documents.first else {
                    // TODO: No hay ninguna ruta activa
                    return
                }

                let route = try document.data(as: Route.self)
                
                // TODO: Hay una ruta activa, reactiva el servicio de geolocalización para dicha ruta
                
                DispatchQueue.main.async {
                    LocationService.shared.startTracking(forRouteId: route.id)
                    self.refreshButtonsStatus()
                }
                
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func refreshButtonsStatus() {
        if LocationService.shared.isTracking {
            startTrackingButton.isHidden = true
            stopTrackingButton.isHidden = false
        } else {
            startTrackingButton.isHidden = false
            stopTrackingButton.isHidden = true
        }
    }
    
    @IBAction func startTracking(_ sender: Any) {
        let userId = Auth.auth().currentUser!.uid
        
        Task {
            do {
                let db = Firestore.firestore()
                
                let docRef = try await db.collection("Routes").addDocument(data: [:])
                
                let route = Route(id: docRef.documentID, userId: userId, startDate: Date().millisecondsSince1970, endDate: nil)
                
                try docRef.setData(from: route)
                
                DispatchQueue.main.async {
                    LocationService.shared.startTracking(forRouteId: route.id)
                    self.refreshButtonsStatus()
                }
                
            } catch {
                print("Error creating document: \(error)")
            }
        }
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        if LocationService.shared.routeId == nil { return }
        Task {
            do {
                let db = Firestore.firestore()
                
                try db.collection("Routes").document(LocationService.shared.routeId!).setData(["endDate": Date().millisecondsSince1970], merge: true)
                
                DispatchQueue.main.async {
                    LocationService.shared.stopTracking()
                    self.refreshButtonsStatus()
                }
                
            } catch {
                print("Error creating document: \(error)")
            }
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
