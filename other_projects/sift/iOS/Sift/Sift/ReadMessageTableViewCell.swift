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

class ReadMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblRoomTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(roomData:RoomManagedModel){

        self.lblRoomTitle.text = roomData.roomName
        
        if(roomData.lastDisplayName.capitalizedString.isEmpty || roomData.lastDisplayName == ""){
            self.lblLastMsg.text = "No message sent"
            self.lblLastMsg.font = self.lblLastMsg.font.italic()
            
        }else{
            self.lblLastMsg.text = roomData.lastDisplayName.capitalizedString + ": " + roomData.lastMessage
        }
        self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(roomData.timestamp)
        self.lblRoomTitle.text = roomData.attributes.name.capitalizedString

        dispatch_async(dispatch_get_main_queue()) {
            for userObj : AnyObject in roomData.attributes.users.allObjects {
                if let userGeneric = userObj as? GenericUserManagedModel {
                    //self.imgAvatar.image = UIImage(data: userGeneric.avatarImg)
                    //self.imgAvatar.image = userGeneric.avatarImg

                    var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + userGeneric.avatarOriginal
                    var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
                    URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                 
                    ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in

                        if let image = response.result.value {
                            //obj.avatarImg = UIImageJPEGRepresentation(image.roundImage(), 1)!
                            self.imgAvatar.image = image.roundImage()
                        }
                    }

                    return;
                }
            }
        }
    }
    
    func setUnread(){

        
        self.lblLastMsg.font = self.lblLastMsg.font.bold()
        //self.lblRoomTitle.font = self.lblRoomTitle.font.bold()
    }
    
    func setNormal(){
        self.lblLastMsg.font = UIFont(name: "AvenirNext-UltraLight", size: 14)
        //self.lblRoomTitle.font = UIFont(name: "AvenirNext-Regular", size: 17)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
}
