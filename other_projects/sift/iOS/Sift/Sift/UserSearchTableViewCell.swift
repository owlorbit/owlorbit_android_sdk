//
//  UserSearchTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtPhoneNumber: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(genericUser:GenericUserModel){
        txtName.text = genericUser.firstName + " " + genericUser.lastName
        txtEmail.text = "email: " + genericUser.email
        txtPhoneNumber.text = "phone: " + genericUser.phoneNumber
    }
    
    class func cellHeight()->CGFloat{
        return 68.0
    }
    
}
