//
//  SettingsViewController.swift
//  TrackingApp
//
//  Created by Tardes on 5/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UITableViewController {
    
    var user: User? = nil
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var signOutCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setProfileStyle()
        
        fetchUserData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func fetchUserData() {
        
        let userId = Auth.auth().currentUser!.uid
        
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(userId)
            
            do {
                user = try await docRef.getDocument(as: User.self)
                
                DispatchQueue.main.async {
                    guard let user = self.user else { return }
                    
                    self.usernameLabel.text = user.fullName()
                    
                    if let image = user.profileImageBase64?.imageFromBase64 {
                        self.profileImageView.image = image
                    } else if let url = user.profileImageUrl {
                        self.profileImageView.loadFrom(url: url)
                    }
                }
                
            } catch {
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
        navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = (indexPath.section, indexPath.row)
        
        switch action {
        case (0, 0):
            break
        case (1, 0):
            signOut()
            break
        default:
            break
        }
        
        // TODO: Si este codigo crece, considera calcular las coordenadas de las celdas (indexPath) dinamicamente usando el siguiente método:
        // tableView.indexPath(for: signOutCell)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NavigateToEditProfile" {
            let editProfileViewController = (segue.destination as! UINavigationController).viewControllers[0] as! ProfileEditViewController
            editProfileViewController.user = user
        }
    }
    
    @IBAction func endEditing(_ sender: UIStoryboardSegue) {
        fetchUserData()
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
