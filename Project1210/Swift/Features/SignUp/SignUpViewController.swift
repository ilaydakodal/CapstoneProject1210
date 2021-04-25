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
        sender.setTitle("Female", forSegmentAt: 0)
        sender.setTitle("Male", forSegmentAt: 1)
        
        switch sender.selectedSegmentIndex {
        case 0: sender.isSelected = true
        case 1: sender.isSelected = true
        default: sender.isSelected = true
        }
    }
    
    // MARK: - Save new contact or update an existing contact
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let userName = usernameTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        let gender = true
        let dateOfBirth = "".dateFromISO8601
        let userPassword = passwordTextField.text ?? ""
        
        let userValues = User(id: id, userName: userName, name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth!, userPassword: userPassword)
            // User(id: id, userName: userName, name: name, surname: surname, gender: gender, dateOfBirth: String(dateOfBirth), userPassword: userPassword)
        
            createNewUser(userValues)
        print(DataBaseCommands.presentRows()!)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "SignUpToMain", sender: nil)
        }
}

// MARK: - Create new user
private func createNewUser(_ userValues: User) {
    
    let userAddedToTable = DataBaseCommands.insertRow(userValues)
    
    if userAddedToTable == true {
        dismiss(animated: true, completion: nil)
    } else {
        showError("Error", message: "This user already exist.")
    }
}
    
    // MARK: - Connect to database and create table.
    private func createTable() {
        let database = DataBaseModel.sharedInstance
        database.createTable()
    }
}
