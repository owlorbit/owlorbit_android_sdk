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

    class func getRooms(resultJSON:(JSON) -> Void, error:(String, errorCode:Int)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/get_all"
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
    
    class func getRoomManaged(roomId:Int, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/get/" + String(roomId)
        let data = ["publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")

                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
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
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
                        resultJSON(post)
                    }else{
                        //post["message"].string!,
                        var success:Bool = post["successful"].bool!
                        if(!success){
                            var message:String = post["message"].string!
                            error(message)
                        }
                    }
                }
        }
    }
    
    class func leaveRoom(roomId:String, resultJSON:(JSON) ->Void, error:(String)->Void)->Void{
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/leave"
        let data = [
            "roomId" : roomId,
            "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
                        resultJSON(post)
                    }else{
                        //post["message"].string!,
                        var success:Bool = post["successful"].bool!
                        if(!success){
                            var message:String = post["message"].string!
                            error(message)
                        }
                    }
                }
        }
    }
    
    class func setHidden(roomId:String, resultJSON:(JSON) ->Void, error:(String)->Void)->Void{
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/set_hidden"
        let data = [
            "roomId" : roomId,
            "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    
                    
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
                        resultJSON(post)
                    }else{
                        //post["message"].string!,
                        var success:Bool = post["successful"].bool!
                        if(!success){
                            var message:String = post["message"].string!
                            error(message)
                        }
                    }
                }
        }
    }
    
    class func setVisible(roomId:String, resultJSON:(JSON) ->Void, error:(String)->Void)->Void{
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/set_visible"
        let data = [
            "roomId" : roomId,
            "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    
                    
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
                        resultJSON(post)
                    }else{
                        //post["message"].string!,
                        var success:Bool = post["successful"].bool!
                        if(!success){
                            var message:String = post["message"].string!
                            error(message)
                        }
                    }
                }
        }
    }
    
    
    class func getRoomAttribute(roomId:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/room/attribute/"
        let data = ["roomId": roomId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["successful"] == nil){
                        //send succesful
                        resultJSON(post)
                    }
                }
        }
    }
}