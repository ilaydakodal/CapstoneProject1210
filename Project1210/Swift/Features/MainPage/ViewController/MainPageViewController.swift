//
//  ViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mainPageSignUpButton: UIButton!
    @IBOutlet weak var mainPageLoginButton: UIButton!
    @IBOutlet weak var mainPageGuestLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPageSignUpButton.applyDefaultStyling(color: .black)
        mainPageLoginButton.applyDefaultStyling(color: .black)
        mainPageGuestLoginButton.applyDefaultStyling(color: .black)
    }

    @IBAction func gusetLoginPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "guestToMap", sender: nil)
        }
    }
}
