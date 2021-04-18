//
//  LoginViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.applyDefaultStyling(color: .black)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        checkAdminLogin()
    }
    
    func checkAdminLogin(){
        let adminUserName: String = "1"
        let adminPassword: String = "1"
        let aName = userNameTextField.text
        let apassword = passwordTextField.text
        if aName == adminUserName && apassword == adminPassword {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "adminView", sender: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Wrong username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
