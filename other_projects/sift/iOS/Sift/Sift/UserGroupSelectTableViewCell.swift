//
//  UserSearchTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage.Swift



class UserGroupSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var circleIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(genericUser:GenericUserManagedModel){
        //self.selectionStyle = UITableViewCellSelectionStyle.None
        txtName.text = genericUser.firstName + " " + genericUser.lastName
        
        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + genericUser.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
                
        let url = NSURL(string: profileImageUrl)
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
        self.imgAvatar!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "owl_orbit"))
        
        if(genericUser.checked){
            imgCheck.hidden = false;
        }else{
            imgCheck.hidden = true;
        }
        
        UIView.animateWithDuration(0.3) {
            self.circleIcon.alpha = 1.0;
            self.layoutIfNeeded()
        }
        
        
        self.circleIcon.hidden = false;
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func populateNoMulti(genericUser:GenericUserManagedModel){
        //self.selectionStyle = UITableViewCellSelectionStyle.None
        txtName.text = genericUser.firstName + " " + genericUser.lastName
        
        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + genericUser.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        
        let url = NSURL(string: profileImageUrl)
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
        self.imgAvatar!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "owl_orbit"))
        imgCheck.hidden = true;
        
        //self.circleIcon.hidden = true;
        
        UIView.animateWithDuration(0.3) {
            self.circleIcon.alpha = 0;
            self.layoutIfNeeded()
        }
        self.selectionStyle = UITableViewCellSelectionStyle.Default
    }
    
    class func cellHeight()->CGFloat{
        return 68.0
    }
    
}
