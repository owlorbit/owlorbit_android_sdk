//
//  NotificationTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage.Swift

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(notification:NotificationModel){

        
        
        var name = "";
        if (notification.messageType != "new_room" && !notification.otherFirstName.isEmpty) {
            name = notification.otherFirstName + " " + notification.otherLastName;
        } else {
            name = notification.firstName + " " + notification.lastName;
        }
        
        lblTitle.text = name
        lblSubtitle.text = notification.message;
        

        var url = "";
        if(notification.messageType != ("new_room") && !notification.otherAvatarOriginal.isEmpty && !notification.otherAvatarOriginal.isEmpty){
            url = notification.otherAvatarOriginal;
        }else{
            url = notification.avatarOriginal;
        }
        
        let profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + url
        print("next lvl \(profileImageUrl)")
        let URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        
        ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
            
            if let image = response.result.value {
                self.imgAvatar.image = image.roundImage()                
            }
        }

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
        var dateConverted:NSDate = dateFormatter.dateFromString(notification.messageCreated)!
        var dateString = dateFormatter.stringFromDate(dateConverted)
        self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(dateString)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
}
