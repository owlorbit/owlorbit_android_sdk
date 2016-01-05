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



class UserSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(genericUser:GenericUserModel){
        txtName.text = genericUser.firstName + " " + genericUser.lastName
        
        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + genericUser.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        
        //let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
        //}
        
        let url = NSURL(string: profileImageUrl)
        self.imgAvatar!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "owl_orbit"))

        /*
        dispatch_async(dispatch_get_main_queue()) {
            ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
                if let image = response.result.value {
                    self.imgAvatar.image = image.roundImage()
                }else{
                    self.imgAvatar.image = UIImage(named:"owl_orbit")!
                }
            }
        }*/
    }
    
    class func cellHeight()->CGFloat{
        return 68.0
    }
    
}
