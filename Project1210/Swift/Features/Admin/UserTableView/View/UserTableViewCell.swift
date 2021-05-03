//
//  UserTableViewCell.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) weak var userNameLabel: UILabel!
    @IBOutlet private(set) weak var nameSurnameLabel: UILabel!
    @IBOutlet private(set) weak var editLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fill(_ presentation: User) {
        
        userNameLabel.text = "\(presentation.userName)"
        //let users = database.user
        nameSurnameLabel.text = "\(presentation.name)" + " " + "\(presentation.surname)"
    }
}
