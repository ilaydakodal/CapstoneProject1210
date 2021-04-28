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
        
        if passwordTextField.text != passwordValidationTextField.text{
            let alert = UIAlertController(title: "Error", message: "Password does not match", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            let userValues = User(id: id, userName: userName, name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth!, userPassword: userPassword)
            
            createNewUser(userValues)
            print(DataBaseCommands.presentRows()!)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "signupToMain", sender: nil)
            }
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
    func createTable() {
        let database = DataBaseModel.sharedInstance
        database.createTable()
    }
}
