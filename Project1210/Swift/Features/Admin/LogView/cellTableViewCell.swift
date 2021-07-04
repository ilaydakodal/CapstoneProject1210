//
//  cellTableViewCell.swift
//  Project1210
//
//  Created by Ilayda Kodal on 6/1/21.
//

import UIKit

class cellTableViewCell: UITableViewCell {

    @IBOutlet weak var ebentDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(_ presentation: User) {
        usernameLabel.text = presentation.userName
        ebentDateLabel.text = presentation.eventDate
    }
}
