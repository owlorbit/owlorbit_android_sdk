//
//  NotificationApiHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/13/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation

///notification/get_users_notifications

import SwiftyJSON
import Alamofire

class NotificationApiHelper{
    
    class func getCode(resultJSON:(JSON) -> Void, error:(String, errorCode:Int)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/notification/get_users_notifications"
        let data = ["publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    error(response.result.description, errorCode: 0)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["error_code"].int == nil){
                        resultJSON(post)
                    }else{
                        error(post["message"].string!, errorCode: post["error_code"].int!)
                    }
                }
        }
    }
    
    
}