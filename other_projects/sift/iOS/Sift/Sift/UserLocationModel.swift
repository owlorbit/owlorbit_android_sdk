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
    
    var deviceId:String = ""
    var avatarOriginal:String=""
    var lastName:String=""

    var userId:String=""    
    var email:String=""
    var phoneNumber:String=""
    var firstName:String=""
    

    var title:String=""
    var subTitle:String=""
    
    var isPerson:Bool = true
    var created:NSDate?
    var coordinate:CLLocationCoordinate2D?

    //meetup specific
    var meetupTitle:String=""
    var subtitle:String=""
    var meetupId:String=""
    
    var latitude:Double=0.0
    var longitude:Double = 0.0
    var avatarImg:UIImage = UIImage()
    
    init(json:JSON, _isPerson:Bool){
        if(json == nil){
            return;
        }
        
        
        if(_isPerson){
            self.userId = json["user_id"].string!
            self.deviceId = json["device_id"].string!
            self.longitude = json["longitude"].string!.toDouble()!
            self.latitude = json["latitude"].string!.toDouble()!
            
            self.avatarOriginal = json["avatar_original"].string!
            self.firstName = json["first_name"].string!.capitalizedString
            self.lastName = json["last_name"].string!.capitalizedString
            self.email = json["email"].string!
            self.phoneNumber = json["phone_number"].string!

        }else{
            

            self.longitude = json["longitude"].string!.toDouble()!
            self.latitude = json["latitude"].string!.toDouble()!
            self.meetupId = json["id"].string!
            self.userId = json["user_id"].string!
            self.meetupTitle = json["title"].string!
            self.subTitle = json["subtitle"].string!            
        }
        
        
        self.isPerson = _isPerson
        var createdStr:String = json["created"].string!

        if(createdStr != ""){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(createdStr)!
            self.created = dateConverted
        }
        
    
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}