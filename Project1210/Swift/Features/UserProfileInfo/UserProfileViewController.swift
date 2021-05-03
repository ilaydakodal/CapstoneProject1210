//
//  UserProfileViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    let userArray = DataBaseCommands.presentRows()
    var user = User(id: 1, userName: "", name: "", surname: "", gender: true, dateOfBirth: "".dateFromISO8601!, userPassword: "")
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    let login = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordButton.applyDefaultStyling(color: .black)
        usernameLabel.text = user.userName
        nameLabel.text = user.name.uppercased()
        surnameLabel.text = user.surname.uppercased()
    }
}
