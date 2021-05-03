//
//  LoginViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {
    var user = User(id: 1, userName: "", name: "", surname: "", gender: true, dateOfBirth: "".dateFromISO8601!, userPassword: "")

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
        
        if checkAdminLogin(adminUser: userNameText, adminPass: passwordText) {
            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let admin = storyBoard.instantiateViewController(withIdentifier: "adminView") as! AdminPageViewController
                admin.modalPresentationStyle = .fullScreen
                self.present(admin, animated: true, completion: nil)
            }
        } else {
            if database.checkUserLogin(username: userNameText, password: passwordText){
                user = database.getUserwithUsername(userNameValue: userNameText)!
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
    
    func checkAdminLogin(adminUser: String, adminPass: String) -> Bool {
        var expression = false
        let adminUserName: String = "admin"
        let adminPassword: String = "admin"
        let aName = userNameTextField.text
        let apassword = passwordTextField.text
        if aName == adminUserName && apassword == adminPassword {
            expression = true
        }
        return expression
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.userProfile.user = user
        }
    }
}


