//
//  LogTableViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/31/21.
//

import UIKit

class LogTableViewController: UITableViewController {
    
    var sections: [String] = []
    let db = DataBaseCommands()
    var log: [String] = []
    let username = [DataBaseCommands.userName]
    let date = [DataBaseCommands.eventDate]
    var sectionData: [Int: [String]] = [:]
    let model = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "log"
        tableView.registerNibCell(cellTableViewCell.self)
        model.connectToDatabase()
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(indexPath, type: cellTableViewCell.self)
        let object = model.cellForRowAt(indexPath: indexPath)
        
        if let logCell = cell as? cellTableViewCell {
            logCell.fill(object)
        }
        
        return cell
    }
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        model.loadDataFromSQLiteDatabase()
    }
}
