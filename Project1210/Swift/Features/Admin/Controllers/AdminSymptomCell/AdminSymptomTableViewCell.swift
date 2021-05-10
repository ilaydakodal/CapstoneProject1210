//
//  AdminSymptomTableViewCell.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import UIKit

class AdminSymptomTableViewCell: UITableViewCell {

    var parentVC = AdminSymptomTableViewController()
    var symptomArray: [Symptom] = []
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var adminIdLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var moreButtonPressed: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(_ presentation: AdminSymptomCell) {
        idLabel.text = String(presentation.symptomCellId)
        if presentation.adminSymptomCellId == 0 {
            adminIdLabel.text = "Admin_Id"
            userIdLabel.text = String(presentation.userIdCell)
        } else if presentation.userIdCell == 0 {
            userIdLabel.text = "User_Id"
            adminIdLabel.text = String(presentation.adminSymptomCellId)
        }
    }
}
