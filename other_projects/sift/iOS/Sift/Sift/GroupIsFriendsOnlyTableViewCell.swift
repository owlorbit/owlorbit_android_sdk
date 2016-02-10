//
//  GroupIsFriendsOnlyTableViewCell.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/8/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class GroupIsFriendsOnlyTableViewCell: UITableViewCell {

    @IBOutlet weak var swFriendsOnly: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func swFriendsOnlyChange(sender: AnyObject) {
        CreateGroupManager.isFriendsOnly = swFriendsOnly.on
    }
}
