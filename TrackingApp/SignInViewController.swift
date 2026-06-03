//
//  ViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
    }

    @IBAction func signIn(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authResult, error in
            guard error == nil else {
                print("Error creating user: \(error!)")
                
                let alert = UIAlertController(title: "Sign In error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
    }
}

