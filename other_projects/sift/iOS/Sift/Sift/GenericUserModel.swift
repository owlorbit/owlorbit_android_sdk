//
//  GenericUserModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import SwiftyJSON

class GenericUserModel: NSObject {
    
    var userId:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var phoneNumber:String = ""
    var accountType:String = ""
    var avatarOriginal:String = ""
    
    
    //id, first_name, last_name, email, phone_number, account_type, avatar_original
    
    init(json:JSON){
        self.userId = json["id"].string!
        self.firstName = json["first_name"].string!
        self.lastName = json["last_name"].string!
        self.email = json["email"].string!
        self.phoneNumber = json["phone_number"].string!
        self.accountType = json["account_type"].string!
        self.avatarOriginal = (json["avatar_original"].error == nil) ? json["avatar_original"].string! : ""
    }
    
    /*init() {
        
        
        
        // provide default values
        userId = ""
        firstName = ""
        lastName = ""
        email = ""
        
        // use optional binding the selectively populate the properties
        if let n = d["name"] as? NSString {
            name = n
        }
        if let a = d["amount"] as? NSNumber {
            amount = a.doubleValue
        }
        if let d = d["description"] as? NSString {
            description = d
        }
    }
}*/

}
