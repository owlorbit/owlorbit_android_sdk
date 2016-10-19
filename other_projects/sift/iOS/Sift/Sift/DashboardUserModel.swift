//
//  DashboardUserModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/14/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class DashboardUserModel : NSObject {
    
    var roomId:String=""
    var firstName:String=""
    var lastName:String=""
    var roomName:String=""
    var activeTimestamp:String=""
    var created:String=""
    var userId:String=""
    var lastMessageTimestamp:String=""
    var accepted:Bool = false
    
    init(json:JSON){
        if(json == nil){
            return;
        }
        
        self.roomId = (json["room_id"] != nil) ? json["room_id"].string! : ""
        self.activeTimestamp = (json["active_timestamp"] != nil) ? json["active_timestamp"].string! : ""
        self.lastMessageTimestamp = (json["last_message_timestamp"] != nil) ? json["last_message_timestamp"].string! : ""
        self.created = (json["created"] != nil) ? json["created"].string! : ""
        self.roomName = (json["room_name"] != nil) ? json["room_name"].string! : ""
        self.userId = (json["user_id"] != nil) ? json["user_id"].string! : ""
        self.firstName = (json["first_name"] != nil) ? json["first_name"].string! : ""
        self.lastName = (json["last_name"] != nil) ? json["last_name"].string! : ""
        self.accepted = (json["accepted"] != nil) ? ((json["accepted"].string! == "1") ? true : false)  : false
        
        
        /*if(self.accepted){
            print("fucking a")
        }else{
            print("nope22")
        }*/
        
    }
}