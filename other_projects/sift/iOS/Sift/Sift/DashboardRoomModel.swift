//
//  DashboardRoomModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/14/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class DashboardRoomModel : NSObject {
    
    var roomId:String=""
    var lastMessage:String=""
    var lastDisplayName:String=""
    var avatarOriginal:String=""
    var roomName:String=""
    var activeTimestamp:String=""
    var created:String=""
    var userId:String=""
    var lastMessageTimestamp:String=""

    init(json:JSON){
        if(json == nil){
            return;
        }

        self.roomId = (json["room_id"] != nil) ? json["room_id"].string! : ""
        self.lastMessage = (json["last_message"] != nil) ? json["last_message"].string! : ""
        self.lastDisplayName = (json["last_display_name"] != nil) ? json["last_display_name"].string! : ""
        self.activeTimestamp = (json["active_timestamp"] != nil) ? json["active_timestamp"].string! : ""
        self.lastMessageTimestamp = (json["last_message_timestamp"] != nil) ? json["last_message_timestamp"].string! : ""
        self.created = (json["created"] != nil) ? json["created"].string! : ""
        self.roomName = (json["room_name"] != nil) ? json["room_name"].string! : ""
        
        self.userId = (json["user_id"] != nil) ? json["user_id"].string! : ""
        
        self.avatarOriginal = (json["avatar_original"] != nil) ? json["avatar_original"].string! : ""
    }
}