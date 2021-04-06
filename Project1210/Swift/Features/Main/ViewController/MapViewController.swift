//
//  MapViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    lazy var userProfile = UserProfileViewController()
    lazy var symptomTestView = SymptomTestViewController()
    @IBAction func MyPageButtonPressed(_ sender: Any) {
        //userProfile.modalPresentationStyle = .fullScreen
        self.present(userProfile, animated: true, completion: nil)
    }
    @IBAction func symptomTestButtonPressed(_ sender: Any) {
        self.present(symptomTestView, animated: true, completion: nil)
    }
    
}
