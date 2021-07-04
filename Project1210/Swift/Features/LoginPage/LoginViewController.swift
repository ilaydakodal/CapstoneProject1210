//
//  LoginViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {
    
    var user = User(id: 1, userName: "", name: "", surname: "", gender: true, dateOfBirth: "".dateFromISO8601!, userPassword: "", testApplied:  false, currentDate: "", eventDate: "", userLat: 41.0422, userLong: 29.0093)

    let database = DataBaseCommands()
    let signUp = SignUpViewController()
    let userArray = DataBaseCommands.presentRows()
    var viewModel: SignUpViewModel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.applyDefaultStyling(color: .black)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
        self.performSegue(withIdentifier: "loginToMain", sender: nil)
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let userNameText = userNameTextField.text,
              let passwordText = passwordTextField.text
        else { return }
        checkEmptyField(username: userNameText, password: passwordText)
        
        if database.checkAdminUser(username: userNameText, password: passwordText) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logiToAdmin", sender: nil)
            }
        } else {
            if database.checkUserLogin(username: userNameText, password: passwordText){
                user = database.getUserwithUsername(userNameValue: userNameText)!
                User.shared = user
                print(user.id)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginToMapPage", sender: self)
                }
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Wrong username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Wrong username or password!")
            }
        }
    }
}

extension LoginViewController {
    func checkEmptyField(username : String , password : String) {
        if username == "" || password  ==  "" {
            showError("Empty", message: "Please Enter Required Details!! ")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.userProfile.user = user
        }
    }
}
