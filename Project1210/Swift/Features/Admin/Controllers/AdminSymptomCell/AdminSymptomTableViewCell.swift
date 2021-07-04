//
//  AdminSymptomTableViewCell.swift
//  Project1210
//
//  Created by Ilayda Kodal on 5/5/21.
//

import UIKit

class AdminSymptomTableViewCell: UITableViewCell {
    
    var parentVC = AdminSymptomTableViewController()
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var adminIdLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
