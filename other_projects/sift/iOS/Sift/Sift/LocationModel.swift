//
//  LocationModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class LocationModel :NSObject {
    
    var userId:String = ""
    var deviceId:String = ""
    var longitude:String=""
    var latitude:String=""
    var created:NSDate?
    var coordinate:CLLocationCoordinate2D?

    init(json:JSON){
        if(json == nil){
            return;
        }

        self.userId = (json["user_id"]) ? json["user_id"].string! : ""
        self.deviceId = (json["device_id"]) ? json["device_id"].string! : ""
        self.longitude = (json["longitude"]) ? json["longitude"].string! : ""
        self.latitude = (json["latitude"]) ? json["latitude"].string! : ""

        var createdStr:String = (json["created"]) ? json["created"].string! : ""

        
        if(createdStr != ""){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(createdStr)!
            self.created = dateConverted
        }

        
        
        //self.created = (json["created"]) ? json["created"].string! : ""
        if(self.latitude != ""){
            if(self.longitude != ""){
                self.coordinate = CLLocationCoordinate2D(latitude: self.latitude.toDouble()!, longitude: self.longitude.toDouble()!)
            }else{
                self.coordinate = CLLocationCoordinate2D()
            }
        }
    }
}