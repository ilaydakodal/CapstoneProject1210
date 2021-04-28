//
//  LoginViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {
    
    let database = DataBaseCommands()
    let signUp = SignUpViewController()
    let userArray = DataBaseCommands.presentRows()
    var loginSuccess = Bool()
    var loggedInUser:String!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.applyDefaultStyling(color: .black)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print(DataBaseCommands.presentRows()!)
        checkAdminLogin()
        if checkEmptyField(username: userNameTextField.text!, password: passwordTextField.text!) == true {
            checkUserExists()
        }
    }
}

extension LoginViewController {
    //UITextFieldDelegate
    func checkEmptyField(username : String , password : String) -> Bool {
        if username == "" || password  ==  "" {
            showError("Empty", message: "Please Enter Required Details!! ")
        }
        return true
    }
    
    func returnUsername() -> String {
        let userName = NSUserName()
        userNameTextField?.text = userName
        return userName
    }
 
    func checkUserExists() {
        for a in userArray! {
            if userNameTextField.text! == a.userName && passwordTextField.text! == a.userPassword {
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mapViewController = storyBoard.instantiateViewController(withIdentifier: "mapnavi") as! UINavigationController
                    mapViewController.modalPresentationStyle = .fullScreen
                    self.present(mapViewController, animated: true, completion: nil)
                    print("bundan var")
                    print(a)
                }
            }
        }
    }
    
    func checkAdminLogin() {
        let adminUserName: String = "admin"
        let adminPassword: String = "admin"
        let aName = userNameTextField.text
        let apassword = passwordTextField.text
        if aName == adminUserName && apassword == adminPassword {
            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let admin = storyBoard.instantiateViewController(withIdentifier: "adminView") as! AdminPageViewController
                admin.modalPresentationStyle = .fullScreen
                self.present(admin, animated: true, completion: nil)
                //self.performSegue(withIdentifier: "loginToAdmin", sender: nil)
            }
        }
    }
}
