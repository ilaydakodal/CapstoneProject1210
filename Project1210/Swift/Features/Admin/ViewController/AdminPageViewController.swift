//
//  AdminPageViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/18/21.
//

import UIKit

class AdminPageViewController: UIViewController {
    
    @IBOutlet weak var addSymptomsButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var userListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSymptomsButton.applyDefaultStyling(color: .black)
        logButton!.applyDefaultStyling(color: .black)
        userListButton!.applyDefaultStyling(color: .black)
    }
}