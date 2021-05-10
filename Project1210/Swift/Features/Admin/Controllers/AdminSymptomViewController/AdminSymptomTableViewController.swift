//
//  AdminSymptomTableViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import UIKit

class AdminSymptomTableViewController: UITableViewController {
    var admin = Admin.shared
    let database = DataBaseCommands()
    
    var thisAdmin = Admin(adminId: 1,
                          admin_username: "",
                          admin_password: "")
    
    var thisSymptom = Symptom(symptomId: 1,
                              fever: "",
                              cough: "",
                              sore_throat: "",
                              shortness_of_breath: "",
                              headeche: "",
                              as_gender: true,
                              age_60_and_above: true,
                              admin_Id: 1,
                              user_Id: 1)
    private var viewModel = UserListViewModel()
    var symptomArray: [Symptom] = []

    
    @IBOutlet var adminSymptomTableView: UITableView!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adminSymptomTableView.delegate = self
        adminSymptomTableView.dataSource = self
        tableView.registerNibCell(AdminSymptomTableViewCell.self)
        adminSymptomTableView.isMultipleTouchEnabled = true
        loadData()
    }
    
    func loadData(){
        if let list = database.symptomList(){
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return symptomArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thatSymptom = symptomArray[indexPath.row]
        let thisCell = AdminSymptomCell(symptomValues: thatSymptom)
        let cell = tableView.dequeCell(indexPath, type: AdminSymptomTableViewCell.self)
        cell.parentVC = self
        cell.idLabel.text = String(thisCell.symptomCellId)
        if thisCell.adminSymptomCellId == 0{
            cell.adminIdLabel.text = "Admin_Id"
            cell.userIdLabel.text = String(thisCell.userIdCell)
        } else if thisCell.userIdCell == 0 {
            cell.userIdLabel.text = "User_Id"
            cell.adminIdLabel.text = String(thisCell.adminSymptomCellId)
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
            let thisCell = AdminSymptomCell(symptomValues: selectedSymptom)
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
        let alert = UIAlertController(title: "Full Information!",
                                      message: "Fever: \(thatSymptom.fever), Cough: \(thatSymptom.cough), Sore Throat: \(thatSymptom.sore_throat), Shortness of Breath: \(thatSymptom.shortness_of_breath), Gender: \(thatSymptom.as_gender), Age Range: \(thatSymptom.age_60_and_above), Admin Id: \(thatSymptom.admin_Id), User Id: \(thatSymptom.user_Id)", preferredStyle: .alert)
                                      
                                      alert.addAction(UIAlertAction(title: "OK", style: .default))
                                      present(alert, animated: true, completion: nil)
    }
}
