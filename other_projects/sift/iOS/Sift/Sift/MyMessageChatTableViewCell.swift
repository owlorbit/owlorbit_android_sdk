//
//  MyMessageChatTableViewCell.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 6/3/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class MyMessageChatTableViewCell: UITableViewCell {

    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
