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

class ChatApiHelper{
    
    
    class func sendMessage(message:MessageModel, created:String, resultJSON:(JSON) -> Void) -> Void {

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/message/send"
        let data = ["message":message.text(), "roomId": message.roomId(), "created" : created, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
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
    

    class func sendMessage(message:String, roomId:String, created:String, resultJSON:(JSON) -> Void, error:(String, errorCode:Int)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/message/send"
        let data = ["message":message, "roomId": roomId, "created" : created, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
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
    
    class func initChatMessage(message:String, userIds:NSMutableArray, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/message/init"
        let data = ["message":message, "userIds": userIds, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        

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
    
    class func test(resultJSON:(JSON) -> Void) -> Void {

        var url:String = ProjectConstants.ApiBaseUrl.value + "/message/test"
        Alamofire.request(.POST, url, encoding: .URL)
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