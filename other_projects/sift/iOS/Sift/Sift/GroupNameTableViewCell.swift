//
//  GroupNameTableViewCell.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/8/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class GroupNameTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func textFieldShouldReturn(sender: AnyObject) {
        txtName.resignFirstResponder()
    }
    
    @IBAction func doneEditingTextField(sender: AnyObject) {
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onEditTextField(sender: AnyObject) {
        CreateGroupManager.roomName = txtName.text!
    }
}
