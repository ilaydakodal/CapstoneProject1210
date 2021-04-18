//
//  SignUpViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite

class SignUpViewController: UIViewController {
    
    let dataBaseModel = DataBaseModel()
    
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
        dataBaseModel.createTable()
        dataBaseModel.connection()
    }
    
    @IBAction func genderSelected(_ sender: Any) {

            switch genderSegmentControl.selectedSegmentIndex{
            case 0: print("female")
            case 1: print("male")
            default: print("female")
            }
        }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        registerUser()
    }
    
    func registerUser() {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let dateOfBirth = dateOfBirthTextField.text?.dateFromISO8601,
              let gender = genderSegmentControl.selectedSegmentIndex.toBool(),
              let username = usernameTextField.text,
              let password = passwordTextField.text
        else { return }
        
        let registerUser = dataBaseModel.user.insert(dataBaseModel.name <- name,
                                                     dataBaseModel.surname <- surname,
                                                     dataBaseModel.dateOfBirth <- dateOfBirth,
                                                     dataBaseModel.gender <- gender,
                                                     dataBaseModel.userName <- username,
                                                     dataBaseModel.userPassword <- password)
        do {
            try self.dataBaseModel.db.run(registerUser)
            print("userRegistered")
        }catch{
            print(error)
        }
    }

}
