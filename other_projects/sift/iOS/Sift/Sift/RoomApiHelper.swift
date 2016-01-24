//
//  ChatApiHelper.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/29/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RoomApiHelper{

    class func getRooms(pageIndex:Int, resultJSON:(JSON) -> Void, error:(String, errorCode:Int)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/get_recent/" + String(pageIndex)
        let data = ["publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    print(response.result.error!)
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
    
    class func getRoomManaged(roomId:Int, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/get/" + String(roomId)
        let data = ["publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
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
    
    class func getRoomMessages(roomId:String, pageIndex:Int, resultJSON:(JSON) -> Void, error:(String)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/message/get_by_room/" + String(pageIndex)
        let data = ["roomId":roomId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    error("error calling GET on \(response.result)")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["hasFailed"].isEmpty){
                        resultJSON(post)
                    }else{
                        error(value as! String)
                    }
                }
        }
    }
    
    
    
    class func getRoomAttribute(roomId:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/attribute/"
        let data = ["roomId": roomId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        print("fucawef \(roomId)")

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
}