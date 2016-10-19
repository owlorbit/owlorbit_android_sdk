//
//  NotificationModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/13/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON


class NotificationModel : NSObject {
    
    var roomId:String=""
    var message:String=""
    var messageType:String=""
    var roomName:String=""
    var accepted:String=""
    var otherAvatarOriginal:String=""
    var otherLastName:String=""
    var userId:String=""
    var avatarOriginal:String=""
    var messageCreated:String=""
    var firstName:String=""
    var lastName:String=""
    var otherFirstName:String=""
    var messageId:String=""
    
    
    init(json:JSON){
        if(json == nil){
            return;
        }
        
        self.roomId = (json["room_id"] != nil) ? json["room_id"].string! : ""
        self.message = (json["message"] != nil) ? json["message"].string! : ""
        self.messageType = (json["message_type"] != nil) ? json["message_type"].string! : ""
        self.roomName = (json["room_name"] != nil) ? json["room_name"].string! : ""
        self.accepted = (json["accepted"] != nil) ? json["accepted"].string! : ""
        self.otherAvatarOriginal = (json["other_avatar_original"] != nil) ? json["other_avatar_original"].string! : ""
        self.otherLastName = (json["other_last_name"] != nil) ? json["other_last_name"].string! : ""
        self.userId = (json["user_id"] != nil) ? json["user_id"].string! : ""
        self.avatarOriginal = (json["avatar_original"] != nil) ? json["avatar_original"].string! : ""
        self.messageCreated = (json["message_created"] != nil) ? json["message_created"].string! : ""
        self.firstName = (json["first_name"] != nil) ? json["first_name"].string! : ""
        self.lastName = (json["last_name"] != nil) ? json["last_name"].string! : ""
        self.otherFirstName = (json["other_first_name"] != nil) ? json["other_first_name"].string! : ""
        self.messageId = (json["message_id"] != nil) ? json["message_id"].string! : ""
        
        
    }
}