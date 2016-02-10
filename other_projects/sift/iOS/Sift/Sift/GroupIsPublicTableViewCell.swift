//
//  GroupIsPublicTableViewCell.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/8/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class GroupIsPublicTableViewCell: UITableViewCell {

    @IBOutlet weak var swPublic: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func swPublicChange(sender: AnyObject) {        
        CreateGroupManager.isPublic = swPublic.on
    }
}
