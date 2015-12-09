//
//  GenericUserModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/25/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoomModel: NSObject {
    //u.id as user_id, room_id, first_name, last_name, r.name, last_message_timestamp
    var userId:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var roomId:String = ""
    var roomName:String = ""
    var attributes:RoomAttributeModel = RoomAttributeModel()
    
    var lastMessage:String = ""
    var avatarOriginal:String = ""
    var timestamp:String = ""
    //var lastMessageTimestamp:NSDate = NSDate()

    init(json:JSON){
        
        if(json == nil){
            return;
        }
        self.userId = json["user_id"].string!
        self.firstName = json["first_name"].string!
        self.lastName = json["last_name"].string!
        self.roomId = json["room_id"].string!
        self.roomName = (json["room_name"]) ? json["room_name"].string! : ""
        self.lastMessage = (json["message"].error == nil) ? json["message"].string! : ""        
        self.timestamp = (json["created"].error == nil) ? json["created"].string! : ""

        //self.lastMessageBy = (json["last_message_by"].error == nil) ? json["last_message_by"].string! : ""
        //self.lastMessageTimestamp = json["last_message_timestamp"].string
    }
    
}