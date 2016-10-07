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

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(userLocationModel:UserLocationModel){

        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
        
        self.lblTitle.text = userLocationModel.firstName + " " + userLocationModel.lastName
        
        let profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + userLocationModel.avatarOriginal
        let URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)

        ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
            
            if let image = response.result.value {
                self.imgAvatar.image = image
            }
        }
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
}
