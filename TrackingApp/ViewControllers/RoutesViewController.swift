//
//  RoutesViewController.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RoutesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var routeList: [Route] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRoutes()
    }
    
    func fetchRoutes() {
        let userId = Auth.auth().currentUser!.uid
        
        var routes = [Route]()
        Task {
            do {
                let db = Firestore.firestore()
                let querySnapshot = try await db.collection("Routes").whereField("userId", isEqualTo: userId).getDocuments()
                for document in querySnapshot.documents {
                    let route = try document.data(as: Route.self)
                    routes.append(route)
                    print("\(document.documentID) => \(document.data())")
                }
                
                routeList = routes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Route Cell", for: indexPath) as! RouteViewCell
        let route = routeList[indexPath.row]
        cell.configure(with: route)
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as! MapViewController
        let indexPath = tableView.indexPathForSelectedRow!
        mapViewController.route = routeList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
