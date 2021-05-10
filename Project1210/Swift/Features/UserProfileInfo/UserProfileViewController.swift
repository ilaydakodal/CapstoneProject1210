//
//  UserProfileViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user = User.shared
    let database = DataBaseCommands()
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordButton.applyDefaultStyling(color: .black)
        usernameLabel.text = user?.userName
        nameLabel.text = " Name: " + "              " + (user?.name.uppercased())!
        surnameLabel.text = " Surname: " + "         " +  (user?.surname.uppercased())!
        dateOfBirthLabel.text = " Date of birth: " + "   " + ((user?.dateOfBirth.iso8601)!)
    }
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        showPasswordAlert()
    }
}

extension UserProfileViewController {
    
    func showPasswordAlert() {
        
        var oldPassword = ""
        var newPassword = ""
        var reEnterPassword = ""
        
        let alert = UIAlertController(title: "Change Password",
                                      message: "Please fill the required fields!",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your old password.."
            textField.isSecureTextEntry = true
        })
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter a new password.."
            textField.isSecureTextEntry = true
        })
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Re-enter the new password.."
            textField.isSecureTextEntry = true
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        let acceptAction = UIAlertAction(title: "Enter", style: .default) { [self]  action in
            oldPassword = alert.textFields![0].text!
            newPassword = alert.textFields![1].text!
            reEnterPassword = alert.textFields![2].text!
            
            print(self.user!.userPassword)
            if self.user!.userPassword == oldPassword && oldPassword != newPassword && reEnterPassword == newPassword {
                let newAlert = UIAlertController(title: "Successful!", message: "Your password is updated!", preferredStyle: .alert)
                newAlert.addAction(UIAlertAction(title: "OK!", style: .default, handler: { (_) in
                    self.database.updatePassword(newUserPassword: newPassword, userValue: self.user! )
                }))
                self.present(newAlert, animated: true, completion: nil)
            }
            
            else{
                let newAlert = UIAlertController(title: "Oops!", message: "Wrong old password!", preferredStyle: .alert)
                let completeAction = UIAlertAction(title: "OK!", style: .default)
                newAlert.addAction(completeAction)
                self.present(newAlert, animated: true, completion: nil)
            }
            print(newPassword)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        self.present(alert, animated: true)
    }
}
