//
//  UserLocationModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/6/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserLocationModel :NSObject {
    
    var longitude:String = ""
    var deviceId:String = ""
    var avatarOriginal:String=""
    var lastName:String=""
    var latitude:String=""
    var userId:String=""    
    var email:String=""
    var phoneNumber:String=""
    var firstName:String=""
    
    var isPerson:Bool = true
    
    
    //meetup specific
    var title:String=""
    var subtitle:String=""

    var created:NSDate?
    var coordinate:CLLocationCoordinate2D?
    
    init(json:JSON, _isPerson:Bool){
        if(json == nil){
            return;
        }
        
        self.userId = json["user_id"].string!
        self.deviceId = json["device_id"].string!
        self.longitude = json["longitude"].string!
        self.latitude = json["latitude"].string!
        
        self.avatarOriginal = json["avatar_original"].string!
        self.firstName = json["first_name"].string!.capitalizedString
        self.lastName = json["last_name"].string!.capitalizedString
        self.email = json["email"].string!
        self.phoneNumber = json["phone_number"].string!                
        self.isPerson = _isPerson
        var createdStr:String = json["created"].string!
        
        
        if(createdStr != ""){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(createdStr)!
            self.created = dateConverted
        }

        if(self.latitude != ""){
            if(self.longitude != ""){
                self.coordinate = CLLocationCoordinate2D(latitude: self.latitude.toDouble()!, longitude: self.longitude.toDouble()!)
            }else{
                self.coordinate = CLLocationCoordinate2D()
            }
        }
    }
}