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
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationTextField: UITextField!
    
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
    }
    
    // MARK: - Save new contact or update an existing contact
    @IBAction func signUpPressed(_ sender: UIButton) {
        verifyPassword()
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let userName = usernameTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        let gender = true
        let dateOfBirth = "".dateFromISO8601
        let userPassword = passwordTextField.text ?? ""
        
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
        var existingUser = dbc.getUserwithUsername(userNameValue: userName)
        
        if  existingUser?.userName == "" {
            existingUser?.id = id
            existingUser?.name = name
            existingUser?.surname = surname
            existingUser?.userName = userName
            existingUser?.gender = gender
            existingUser?.dateOfBirth = dateOfBirth!
            existingUser?.userPassword = userPassword
            DataBaseCommands.insertRow(existingUser!)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "signupToMain", sender: nil)
            }
        } else {
            showError("Oops!", message: "This username has already been taken!")
            Swift.print("Username: \(existingUser!) exists.")
            
        }
        print(DataBaseCommands.presentRows()!)
    }
 
    func verifyPassword() {
        if passwordTextField.text != passwordValidationTextField.text{
            showError("Error", message: "Your password must be at least 8 characters")
            //Please make sure your passwords match
        }
    }

    // MARK: - Connect to database and create table.
    func createTable() {
        let database = DataBaseModel.sharedInstance
        database.createTable()
    }
}
