//
//  SymptomTestViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/6/21.
//

import UIKit


class SymptomTestViewController: UIViewController {

    @IBOutlet weak var testButtonOne: UIButton!
    @IBOutlet weak var testButtonTwo: UIButton!
    @IBOutlet weak var testButtonThree: UIButton!
    @IBOutlet weak var testButtonFour: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testButtonOne.applyDefaultStyling(color: .blue)
        testButtonTwo.applyDefaultStyling(color: .blue)
        testButtonThree.applyDefaultStyling(color: .blue)
        testButtonFour.applyDefaultStyling(color: .blue)
    }
}
