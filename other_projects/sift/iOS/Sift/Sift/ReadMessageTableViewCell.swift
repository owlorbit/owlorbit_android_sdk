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
    
    let downloader = ImageDownloader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(roomData:RoomModel){
        self.lblRoomTitle.text = roomData.roomName
        self.lblLastMsg.text = roomData.firstName + ": " + roomData.lastMessage

        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + roomData.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(roomData.timestamp)
        //mysqlDatetimeFormattedAsTimeAgo
        
        downloader.downloadImage(URLRequest: URLRequest) { response in
            if let image = response.result.value {
                self.imgAvatar.image = image.roundImage()
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
