//
//  RoomCellModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/30/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoomAttributeModel: NSObject {

    var users:NSMutableArray = []
    var name:String = ""

    override init(){
        
    }

    init(json:JSON){
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;

        for (key,subJson):(String, SwiftyJSON.JSON) in json["room_attributes"] {
            var genericUser:GenericUserModel = GenericUserModel(json: subJson)            
            users.addObject(genericUser);
            self.name += genericUser.firstName + ", "
        }
        self.name.removeRange(self.name.endIndex.advancedBy(-2)..<self.name.endIndex)
    }
}