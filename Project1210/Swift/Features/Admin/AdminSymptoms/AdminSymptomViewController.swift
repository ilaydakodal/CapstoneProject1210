//
//  AdminSymptomViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/3/21.
//

import UIKit

class AdminSymptomViewController: UIViewController {
    
    
    @IBOutlet weak var coughTextField: UITextField!
    @IBOutlet weak var feverTextField: UITextField!
    @IBOutlet weak var shortnessOfBreathTextField: UITextField!
    @IBOutlet weak var headacheTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    let feverArray = ["<35.0 °C (Hypothermia)",
                      "36.5–37.5 °C (Normal)",
                      ">37.5 or 38.3 °C (Fever)",
                      ">40.0 or 41.0 °C (Hypothermia)"]
    
    let yesNoArray = ["Yes", "No"]
    
    var coughPicker = UIPickerView()
    var feverPicker = UIPickerView()
    var shortnessOfBreathPicker = UIPickerView()
    var headachePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coughTextField.inputView = coughPicker
        feverTextField.inputView = feverPicker
        shortnessOfBreathTextField.inputView = shortnessOfBreathPicker
        headacheTextField.inputView = headachePicker
        
        coughPicker.delegate = self
        coughPicker.dataSource = self
        coughPicker.tag = 1
        
        feverPicker.delegate = self
        feverPicker.dataSource = self
        feverPicker.tag = 2
        
        shortnessOfBreathPicker.delegate = self
        shortnessOfBreathPicker.dataSource = self
        shortnessOfBreathPicker.tag = 3
        
        headachePicker.delegate = self
        headachePicker.dataSource = self
        headachePicker.tag = 4
        
        configureView()
        
    }
    
    func configureView() {
        saveButton.applyDefaultStyling(color: .black)
        listButton.applyDefaultStyling(color: .black)
        createToolbar()
    }
    
}

extension AdminSymptomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return yesNoArray.count
        case 2:
            return feverArray.count
        case 3:
            return yesNoArray.count
        case 4:
            return yesNoArray.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return yesNoArray[row]
        case 2:
            return String(describing: feverArray[row])
        case 3:
            return yesNoArray[row]
        case 4:
            return yesNoArray[row]
        default:
            return "not found"
        }
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AdminSymptomViewController.closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        
        coughTextField.inputAccessoryView = toolbar
        feverTextField.inputAccessoryView = toolbar
        shortnessOfBreathTextField.inputAccessoryView = toolbar
        headacheTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func closePickerView()
        {
            view.endEditing(true)
        }
}

