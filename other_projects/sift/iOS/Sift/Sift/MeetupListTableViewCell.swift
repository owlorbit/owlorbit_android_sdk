//
//  ReadMessageTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage.Swift


protocol MeetupListTableViewCellDelegate {
    func clickUser(userLocationModel:UserLocationModel)
}

class MeetupListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    var delegate:UserListTableViewCellDelegate?
    var userLocationModel:UserLocationModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(userLocationModel:UserLocationModel){
        self.userLocationModel = userLocationModel        
        self.lblTitle.text = userLocationModel.meetupTitle
        self.lblSubtitle.text = userLocationModel.subTitle
        //self.lblTitle.text = userLocationModel.firstName + " " + userLocationModel.lastName
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        delegate?.clickUser(userLocationModel)
    }
}
