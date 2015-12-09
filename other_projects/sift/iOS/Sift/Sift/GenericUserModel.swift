//
//  GenericUserModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage.Swift

class GenericUserModel: NSObject {
    
    var userId:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var phoneNumber:String = ""
    var accountType:String = ""
    var avatarOriginal:String = ""
    var avatarImg:UIImage = UIImage()
    
    init(json:JSON){
        self.userId = (json["id"].error == nil) ? json["id"].string! : ""
        self.firstName = (json["first_name"].error == nil) ? json["first_name"].string! : ""
        self.lastName = (json["last_name"].error == nil) ? json["last_name"].string! : ""
        self.email = (json["email"].error == nil) ? json["email"].string! : ""
        self.phoneNumber = (json["phone_number"].error == nil) ? json["phone_number"].string! : ""
        self.accountType = (json["account_type"].error == nil) ? json["account_type"].string! : ""
        self.avatarOriginal = (json["avatar_original"].error == nil) ? json["avatar_original"].string! : ""
    }

}
