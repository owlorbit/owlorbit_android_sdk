//
//  RoomCellModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/30/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

class RoomCellModel: NSObject {
    //u.id as user_id, room_id, first_name, last_name, r.name, last_message_timestamp
    var userIds:NSMutableArray = []
    var name:String = ""
    var lastMessage:String = ""
    var lastMessageBy:String = ""
    var otherProfileImage:String = ""
    var roomId:String = ""

    init(data:NSMutableArray, roomId:String){
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        self.roomId = roomId

        for roomData in data {
            var roomModel:RoomModel = roomData as! RoomModel

            self.lastMessage = roomModel.lastMessage
            self.lastMessageBy = roomModel.lastMessageBy
            userIds.addObject(roomModel.userId)
            if(user.userId != roomModel.userId){
                self.name += roomModel.firstName + ", "
            }
        }
        
        self.name.removeRange(self.name.endIndex.advancedBy(-2)..<self.name.endIndex)
        print(self.name)
    }
}