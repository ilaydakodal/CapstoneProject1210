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
    var viewModel: UserListViewModel!
    
    @IBOutlet var userTableView: UITableView!
    
    //let database = DataBaseModel()
    
    override func viewDidLoad() {
        self.viewDidLoad()
        title = "User List"
        userTableView.delegate = self
        userTableView.dataSource = self
        bindViewModel()
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
        tableView.registerNibCell(UserTableViewCell.self)
        smallPresentation.append(UserInfoPresentation(id: "", userName: "", name: "", surname: "", gender: "", dateOfBirth: ""))
    }
    
    func bindViewModel(){
        viewModel = UserListViewModel()
        viewModel.changeHandler = { [weak self] change in
            self!.applyChange(change)
        }
    }
    
    func applyChange(_ change: UserListViewModel.Change) {
        switch change {
        case .presentation(let presentation):
            self.smallPresentation = presentation.smallInfoPresentation
            cellView.fill(presentation.smallInfoPresentation[0])
            tableView.reloadData()
        case .alert:
            break
        }
    }
}

// MARK: - Table view data source
extension UserListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
        //smallPresentation.count
        //return database.getUserList().count
    }
    
    // Configure the cell...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(indexPath, type: UserTableViewCell.self)
        cell.fill(smallPresentation[indexPath.row])
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
