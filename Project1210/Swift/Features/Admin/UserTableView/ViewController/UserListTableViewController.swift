//
//  UserListTableViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/18/21.
//

import UIKit

class UserListTableViewController: UITableViewController  {
    
    private var smallPresentation: [UserInfoPresentation] = []
    private lazy var cellView = UserTableViewCell()
    private var viewModel = UserListViewModel()
    
    @IBOutlet var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        viewModel.connectToDatabase()
        tableView.registerNibCell(UserTableViewCell.self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        tableView.reloadData()
    }
    
    private func loadData() {
        viewModel.loadDataFromSQLiteDatabase()
    }
    
    func configurView(name: String, userSurname: String) {
        
        //User.append(UserInfoPresentation(id: "", userName: "", name: "", surname: "", gender: "", dateOfBirth: ""))
    }
}

// MARK: - Table view data source
extension UserListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    
    // Configure the cell...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(indexPath, type: UserTableViewCell.self)
        
        let object = viewModel.cellForRowAt(indexPath: indexPath)
        
        if let userCell = cell as? UserTableViewCell {
            userCell.fill(object)
        }
        return cell
    }
    
    // Delete cell from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = viewModel.cellForRowAt(indexPath: indexPath)
            
            // Delete contact from database table
            DataBaseCommands.deleteRow(userId: user.id)
            
            // Updates the UI after delete changes
            self.loadData()
            self.tableView.reloadData()
        }
    }
}
