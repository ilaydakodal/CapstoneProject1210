//
//  AdminSymptomTableViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import UIKit

class AdminSymptomTableViewController: UITableViewController {
    
    private var viewModel = UserListViewModel()
    var admin = Admin.shared
    var thisAdmin = Admin(adminId: 1, admin_username: "", admin_password: "")
    var thisSymptom = Symptom(symptomId: 1, fever: "", cough: "", sore_throat: "",
                              shortness_of_breath: "", headeche: "", as_gender: true, age_60_and_above: true,admin_Id: 1, user_Id: 1, output: 0, lat: 41.0422, long: 29.0093)
    
    var symptomArray: [Symptom] = []
    let database = DataBaseCommands()
    let imagePlus = UIImage(systemName: "plus.rectangle.fill")
    let imageMinus = UIImage(systemName: "minus.rectangle.fill")
    let imageOther = UIImage(systemName: "questionmark.square.fill.ar")
    
    @IBOutlet var adminSymptomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adminSymptomTableView.delegate = self
        adminSymptomTableView.dataSource = self
        adminSymptomTableView.isMultipleTouchEnabled = true
        tableView.registerNibCell(AdminSymptomTableViewCell.self)
        
        loadData()
    }
    
    func loadData(){
        if let list = database.symptomList() {
            for item in list{
                symptomArray.append(item)
            }
        }
        
        DispatchQueue.main.async {
            self.adminSymptomTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thatSymptom = symptomArray[indexPath.row]
        var thisCell = AdminSymptomCellModel(symptomValues: thatSymptom)
        let cell = tableView.dequeCell(indexPath, type: AdminSymptomTableViewCell.self)
        cell.parentVC = self
        cell.idLabel.text = String(thisCell.symptomCellId)
        
        if thisCell.adminSymptomCellId == 0 {
            cell.adminIdLabel.text = "-"
            cell.userIdLabel.text = String(thisCell.userIdCell)
            let u_user = database.getUser(idValue: thisCell.userIdCell)
            thisCell.latitudeCell = u_user?.userLat ?? 0.0
            thisCell.longitudeCell = u_user?.userLong ?? 0.0
        } else if thisCell.userIdCell == 0 {
            cell.userIdLabel.text = "-"
            cell.adminIdLabel.text = String(thisCell.adminSymptomCellId)
            thisCell.latitudeCell = thatSymptom.lat
            thisCell.longitudeCell = thatSymptom.long
        }
        
        if thisCell.outputCell == 0 {
            cell.contentView.backgroundColor = .systemPurple
            cell.statusImage.image = imageMinus
        } else if thisCell.outputCell == 1 {
            cell.contentView.backgroundColor = .red
            cell.statusImage.image = imagePlus
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            let selectedSymptom = symptomArray[indexPath.row]
            let thisCell =  AdminSymptomCellModel(symptomValues: selectedSymptom)
            let u_user_id = selectedSymptom.user_Id
            let u_user = database.getUser(idValue: u_user_id)
            database.updateUserEventDate(eventTime: u_user?.currentDate ?? "", userValues: u_user!)
            symptomArray.remove(at: indexPath.row)
            symptomArray.remove(at: indexPath.row)
            thisCell.deleteRow()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print(symptomArray.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thatSymptom = symptomArray[indexPath.row]
        let alert = UIAlertController(title: "Full Information!", message: "Fever: \(thatSymptom.fever), Cough: \(thatSymptom.cough), Sore Throat: \(thatSymptom.sore_throat), Shortness of Breath: \(thatSymptom.shortness_of_breath), Gender: \(thatSymptom.as_gender), Admin Id: \(thatSymptom.admin_Id), Output: \(thatSymptom.output), User Id: \(thatSymptom.user_Id)", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
