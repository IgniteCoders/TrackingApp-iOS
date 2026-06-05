//
//  SignUpViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirm = passwordConfirmTextField.text ?? ""
        
        if password != passwordConfirm {
            let alert = UIAlertController(title: "Sign Up error", message: "Passwords do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) { [unowned self] authResult, error in
            guard error == nil else {
                print("Error creating user: \(error!)")
                
                let alert = UIAlertController(title: "Sign Up error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            createUser(withId: authResult!.user.uid)
            
            
            let alert = UIAlertController(title: "Sign Up", message: "Account created successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in 
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createUser(withId userId: String) {
        let username = usernameTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthDatePicker.date.millisecondsSince1970
        let gender = genderSegmentedControl.selectedSegmentIndex
        
        let user = User(id: userId, username: username, firstName: firstName, lastName: lastName, gender: gender, birthDate: birthDate, profileImageUrl: nil)
        
        do {
            let db = Firestore.firestore()
            try db.collection("Users").document(userId).setData(from: user)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
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
