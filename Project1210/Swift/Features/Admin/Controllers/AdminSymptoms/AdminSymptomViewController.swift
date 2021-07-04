//
//  AdminSymptomViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/3/21.
//

import UIKit
import CoreLocation

class AdminSymptomViewController: UIViewController {
    
    let newSymptom = Symptom(symptomId: 1, fever: "",
                             cough: "", sore_throat: "",
                             shortness_of_breath: "", headeche: "",
                             as_gender: true, age_60_and_above: true,admin_Id: 1, user_Id: 1, output: 0, lat: 41.0422, long: 29.0093)
                             
                             
    let thisView = AdminSymptomTableViewController()
    let database = DataBaseCommands()
    var data: [Double] = []
    var testModel = TestModel()
    var model: finalmodel?

    @IBOutlet weak var adminNameTextField: UITextField!
    @IBOutlet weak var coughTextField: UITextField!
    @IBOutlet weak var feverTextField: UITextField!
    @IBOutlet weak var shortnessOfBreathTextField: UITextField!
    @IBOutlet weak var headacheTextField: UITextField!
    @IBOutlet weak var soreThroatTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var ageSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    
    let feverArray = ["<35.0 °C (Hypothermia)",
                      "36.5–37.5 °C (Normal)",
                      ">37.5 or 38.3 °C (Fever)",
                      ">40.0 or 41.0 °C (Hypothermia)"]
    
    let yesNoArray = ["Yes", "No"]
    
    var coughPicker = UIPickerView()
    var feverPicker = UIPickerView()
    var soreThoratPicker = UIPickerView()
    var shortnessOfBreathPicker = UIPickerView()
    var headachePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = try? finalmodel(configuration: .init())
    }
    
    @IBAction func listButtonPressed(_ sender: Any) {
        let db = DataBaseCommands()
        print(db.symptomList()!.count)
        DispatchQueue.main.async {
            self.present(AdminSymptomTableViewController(), animated: true, completion: nil)
            self.thisView.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        coronaPrediction()
        
        guard let ageRange = ageSegmentControl.selectedSegmentIndex.toBool(),
              let selectedGender = genderSegmentControl.selectedSegmentIndex.toBool(),
              let selectedCough = coughTextField.text,
              let selectedFever = feverTextField.text,
              let selectSoreThroat = soreThroatTextField.text,
              let selectedShortnessOfBreath = shortnessOfBreathTextField.text,
              let selectedHeadache = headacheTextField.text,
              let adminName = adminNameTextField.text,
              let latValue = Double(latTextField.text ?? ""),
              let longValue = Double(longTextField.text ?? "")
        else {return}
        
        var newSymptom = Symptom(symptomId: 1, fever: "",
                                 cough: "", sore_throat: "",
                                 shortness_of_breath: "", headeche: "",
                                 as_gender: true, age_60_and_above: true,admin_Id: 1, user_Id: 1, output: 0, lat: 41.0422, long: 29.0093)
        
        if let thisAdmin = database.getAdmin(adminUsername: adminName) {
            newSymptom.as_gender = selectedGender
            newSymptom.age_60_and_above = ageRange
            newSymptom.cough = selectedCough
            newSymptom.fever = selectedFever
            newSymptom.sore_throat = selectSoreThroat
            newSymptom.shortness_of_breath = selectedShortnessOfBreath
            newSymptom.headeche = selectedHeadache
            newSymptom.admin_Id = thisAdmin.adminId
            newSymptom.user_Id = 0
            newSymptom.lat = latValue as CLLocationDegrees
            newSymptom.long = longValue as CLLocationDegrees
            newSymptom.output = testModel.output
            print(selectedCough)
            
            database.insertSymptoms(symptomValues: newSymptom)
            let db = DataBaseCommands()
            print(db.symptomList()?.count)
        }
    }
        
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func configureView() {
        saveButton.applyDefaultStyling(color: .black)
        listButton.applyDefaultStyling(color: .black)
        
        coughTextField.inputView = coughPicker
        feverTextField.inputView = feverPicker
        soreThroatTextField .inputView = soreThoratPicker
        shortnessOfBreathTextField.inputView = shortnessOfBreathPicker
        headacheTextField.inputView = headachePicker
        
        coughPicker.delegate = self
        coughPicker.dataSource = self
        coughPicker.tag = 1
        
        feverPicker.delegate = self
        feverPicker.dataSource = self
        feverPicker.tag = 2
        
        soreThoratPicker.delegate = self
        soreThoratPicker.dataSource = self
        soreThoratPicker.tag = 3
        
        shortnessOfBreathPicker.delegate = self
        shortnessOfBreathPicker.dataSource = self
        shortnessOfBreathPicker.tag = 4
        
        headachePicker.delegate = self
        headachePicker.dataSource = self
        headachePicker.tag = 5
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
        case 5:
            return yesNoArray.count
        default:
            return 0
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
        case 5:
            return yesNoArray[row]
        default:
            return "not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            coughTextField.text = yesNoArray[row]
            coughTextField.resignFirstResponder()
        } else if pickerView.tag == 2 {
            feverTextField.text = feverArray[row]
            feverTextField.resignFirstResponder()
        } else if pickerView.tag == 3 {
            soreThroatTextField.text = yesNoArray[row]
            soreThroatTextField.resignFirstResponder()
        } else if pickerView.tag == 4 {
            shortnessOfBreathTextField.text = yesNoArray[row]
            shortnessOfBreathTextField.resignFirstResponder()
        } else {
            headacheTextField.text = yesNoArray[row]
            headacheTextField.resignFirstResponder()
        }
    }
    
    @objc func closePickerView() {
        view.endEditing(true)
    }
}

