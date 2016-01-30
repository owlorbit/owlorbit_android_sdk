//
//  LocationApiHelper.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/29/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LocationApiHelper{

    class func getRoomLocations(roomId:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/location/get_all_locations"
        let data = ["roomId": roomId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["hasFailed"].isEmpty){
                        //send succesful
                        resultJSON(post)
                    }
                }
        }
    }
    
    class func sendLocation(longitude:String, latitude:String, resultJSON:(JSON) -> Void, error:(String) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/location/add"
        let data = ["longitude": longitude, "latitude":latitude, "device_id": ApplicationManager.deviceId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        

        if(ApplicationManager.deviceId == ""){
            error("empty device..")
            return
        }
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    print(response.result.error!)
                    
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["hasFailed"].isEmpty){
                        //send succesful
                        resultJSON(post)
                    }else{
                        error("failed")
                    }
                }
        }
    }
}