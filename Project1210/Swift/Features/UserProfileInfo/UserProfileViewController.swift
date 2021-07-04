//
//  UserProfileViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit

protocol TimerManagerDelegate: class {
    func timerManager(controller: UserProfileViewController, userValue: User)
}

class UserProfileViewController: UIViewController {
    
    weak var delegate: TimerManagerDelegate?
    var timer: Timer!
    var eventDate = Date()
    var user = User.shared
    var counter = 60
    
    let symptomView = SymptomTestViewController()
    let database = DataBaseCommands()
    let instance = MapViewController()
    
    
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        
        if user?.gender == false {
            genderImageView.image = #imageLiteral(resourceName: "Wavy_Ppl-04_Single-4")
        } else {
            genderImageView.image = #imageLiteral(resourceName: "Wavy_Ppl-02_Single-1")
        }
    }
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        showPasswordAlert()
    }
}

extension UserProfileViewController {
    
    func startTimer() {
        self.loadView()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let thisUser = database.getUser(idValue: user!.id)
        changePasswordButton.applyDefaultStyling(color: .black)
        let stringBirthDate = dateFormatter.string(from: thisUser!.dateOfBirth)
        usernameLabel.text = user?.userName
        nameLabel.text = " Name: " + "              " + (user?.name.uppercased())!
        surnameLabel.text = " Surname: " + "         " +  (user?.surname.uppercased())!
        dateOfBirthLabel.text = " Date of birth: " + "   " + stringBirthDate
        //let profileUser = database.getUser(idValue: user!.id)!
        //print("test yapildi: \(profileUser.testApplied)")
        if thisUser!.testApplied {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            print("test from user: \(user?.testApplied)")
        }
    }
    
    @objc func UpdateTime() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd'T'HH:mm:ssZ"
        let date = Date()
        let timeUser = database.getUser(idValue: user!.id)!
        let eventDate = database.getUserEventDate(idValue: timeUser.id)
        let thisEventDate = dateFormatter.date(from: eventDate)
        let userCalendar = Calendar.current
        let components = userCalendar.dateComponents([.year,.month,.day, .hour, .minute, .second], from: date)
        let currentDate = userCalendar.date(from: components)
        if thisEventDate ?? "".dateFromISO8601! > currentDate ?? "".dateFromISO8601! {
            let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: thisEventDate!)
            timerLabel.text = "\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        } else if  currentDate ?? "".dateFromISO8601! >= thisEventDate ?? "".dateFromISO8601! {
            timer.invalidate()
            database.updateUser(updateTestStatus: false, userValues: timeUser)
            let updatedUser = database.getUser(idValue: timeUser.id)
            delegate?.timerManager(controller: self, userValue: updatedUser!)
            timerLabel.text = "The COVID-19 quick test is active now!"
        }
    }
    
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
            let passwordUser = database.getUser(idValue: self.user!.id)
            if passwordUser!.userPassword != oldPassword {
                showError("Oops!", message: "Wrong old password!")
            } else if oldPassword == newPassword {
                showError("Oops!", message: "You should enter a different password than the last one")
            } else if reEnterPassword != newPassword {
                showError("Oops", message: "Password validation does not match")
            } else {
                showError("Successful!", message: "Your password is updated!")
                self.database.updatePassword(newUserPassword: newPassword, userValue: self.user!)
            }
            print(newPassword)
        }
            
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        self.present(alert, animated: true)
    }
}
