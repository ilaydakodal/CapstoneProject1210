//
//  SignUpViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class SignUpViewController: UIViewController {
    
    let presentation = UserListTableViewController()
    var viewModel: SignUpViewModel!
    var userArray: Array<Any> = []
    let user = User.shared
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationTextField: UITextField!
    @IBOutlet weak var genderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.applyDefaultStyling(color: .black)
        createTable()
    }
    
    @IBAction func genderSelected(_ sender: UISegmentedControl) {
        genderSegmentControl = sender
        
        switch sender.selectedSegmentIndex {
        case 0: Swift.print(genderSegmentControl.selectedSegmentIndex.toBool() as Any)
        case 1: Swift.print(genderSegmentControl.selectedSegmentIndex.toBool() as Any)
        default: Swift.print(genderSegmentControl.selectedSegmentIndex.toBool() as Any)
        }
        
        if genderSegmentControl.selectedSegmentIndex == 0 {
            genderImageView.image = #imageLiteral(resourceName: "Wavy_Ppl-04_Single-4")
        } else {
            genderImageView.image = #imageLiteral(resourceName: "Wavy_Ppl-02_Single-1")
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        signUpAction()
    }
}

// MARK: - Extension

extension SignUpViewController {
    
    
    // MARK: - Connect to database and create table.
    
    func createTable() {
        let database = DataBaseModel.sharedInstance
        database.createTable()
    }
    
    func signUpAction() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var dateOfBirth_u = Date()
        if let birthDay = dateFormatter.date(from: dateOfBirthTextField.text ?? "") {
            dateOfBirth_u = birthDay
            
            guard let username_u = usernameTextField.text,
                  let name_u = nameTextField.text,
                  let surname_u = surnameTextField.text,
                  let gender_u = genderSegmentControl.selectedSegmentIndex.toBool(),
                  let userPassword_u = passwordTextField.text,
                  let validationPassword = passwordValidationTextField.text
            else { return }
            
            for u  in userArray {
                if usernameTextField.text == ((u as! Dictionary<String,AnyObject>)["userName"] as! String) {
                    print("login Success")
                    //do Something
                    let alert = UIAlertController(title: "Error", message: "This User already exists Try logging in.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            
            let dbc = DataBaseCommands()
            var existingUser = dbc.getUserwithUsername(userNameValue: username_u)
            
            if  existingUser?.userName == "" && username_u.count > 3 {
                if  userPassword_u.count >= 8 {
                    if passwordTextField.text == passwordValidationTextField.text {
                        existingUser?.id = user?.id ?? 0
                        existingUser?.name = name_u
                        existingUser?.surname = surname_u
                        existingUser?.userName = username_u
                        existingUser?.gender = gender_u
                        existingUser?.dateOfBirth = dateOfBirth_u
                        existingUser?.userPassword = userPassword_u
                        DataBaseCommands.insertRow(existingUser!)
                        let db = DataBaseCommands()
                        print(db.getUserList())
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "signupToMain", sender: nil)
                        }
                    } else { showError("Error", message: "Password does not match!") }
                } else { showError("Error", message: "Your password must be at least 8 characters") }
            } else {
                showError("Oops!", message: "This username has already been taken or you should choose a username that has more than 3 characters!")
                Swift.print("Username: \(existingUser!) exists.")
            }
            print(DataBaseCommands.presentRows()!)
            
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Wrong birthday format! (E.g. 11/11/2000)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
