//
//  ReadMessageTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class ReadMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblRoomTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(roomCellModel:RoomCellModel){
        self.lblRoomTitle.text = roomCellModel.name
        self.lblLastMsg.text = roomCellModel.lastMessageBy + ": " + roomCellModel.lastMessage
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
}
