//
//  UserInfoTableViewCell.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit
import SDWebImage

class UserInfoTableViewCell: UITableViewCell {
    
    // UI
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // View model
    var userModel: FirebaseUser? {
        didSet {
            setup()
        }
    }
    
    // Build data
    private func setup() {
        guard let userModel = userModel else { return }
        
        idLabel.text = "⦁ ID: \(userModel.id)"
        nameLabel.text = "⦁ Name (username)\n\t\(userModel.name)"
        addressLabel.text = "⦁ Address\n\t\(userModel.address)"
        contactLabel.text = "⦁ Contact\n\t\(userModel.contact)"
        companyLabel.text = "⦁ Company\n\t\(userModel.company)"
        
        avatarImageView.sd_setImage(with: URL(string: userModel.imageUrl))
    }
}
