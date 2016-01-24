//
//  UserAPIHelper.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Photos
import AlamofireImage.Swift

class UserApiHelper{

    class func createUser(user:RegistrationUser, resultJSON:(JSON) -> Void) -> Void {

        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/add"
        let data = ["email": user.email, "first_name" : user.firstName, "last_name" : user.lastName, "phone_number":user.phoneNumber, "password" : user.password]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
        .responseJSON { response in

            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on \(response)")
                print(response.result.error!)
                return
            }
            
            if let value: AnyObject = response.result.value {
                let post = JSON(value)
                if(post["hasFailed"].isEmpty){
                    resultJSON(post)
                }
            }
        }
    }
    
    class func downloadProfileImage(){
        //request(.GET, "https://httpbin.org/image/png")
      
        let downloader = ImageDownloader()
        let URLRequest = NSURLRequest(URL: NSURL(string: "http://192.168.99.100:8080/uploads/profile_imgs/50.png")!)
        let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: 100.0, height: 100.0))
        print("start download...")
        downloader.downloadImage(URLRequest: URLRequest, filter: filter) { response in

            print("come onnnn")
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print(image)
            }
        }
    }
    
    class func uploadProfileImage(img:UIImage, resultJSON:(JSON) -> Void) -> Void {

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/upload_profile_img"
        let data = ["device_id": ApplicationManager.deviceId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

        Alamofire.upload(.POST, url, multipartFormData: {
            multipartFormData in
            
            if let _image:UIImage = img {
                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
                }
            }

            for (key, value) in data {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            }, encodingCompletion: {
                encodingResult in

                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON{ response in
                        if let value: AnyObject = response.result.value {
                            let post = JSON(value)
                            user.avatarOriginal = (post["original_avatar"]) ? post["original_avatar"].string! : ""
                            PersonalUserModel.save()
                            
                            resultJSON(post)
                            //post["original_avatar"]
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    class func enablePushNotification(deviceId:String, resultJSON:(JSON) -> Void, error:(String)->Void) -> Void {

        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/notification/enable"
        let data = ["deviceId": deviceId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    print(response.result.error!)

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
    
    
    class func updateToken(success:() -> Void, error:(String)->Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/login/go"

        let data = ["email": user.email, "password" : user.password]

        
        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    if(post["hasFailed"].isEmpty){
                        PersonalUserModel.updateUserFromLogin(user.email, password: user.password, serverReturnedData: post)
                        success();
                    }else{
                        error(post["message"].string!)
                    }
                }
        }
    }
    
    
    class func loginUser(email:String, password:String, resultJSON:(JSON) -> Void) -> Void {
        
        var url:String = ProjectConstants.ApiBaseUrl.value + "/login/go"
        let data = ["email": email, "password" : password]

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
    
    class func emailExists(email:String, resultJSON:(JSON) -> Void) -> Void {

        let data = ["email": email]
        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/does_email_exist"

        Alamofire.request(.POST, url, parameters:data, encoding: .URL)
            .responseJSON { response in

                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on \(response.result)")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)

                    resultJSON(post)                    
                }
        }
    }
    
    class func findUser(value:String, resultJSON:(JSON) -> Void) -> Void {

        var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        var escapedString:String = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/find/" + escapedString

        Alamofire.request(.GET, url, encoding: .URL)
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
    
    class func findFriends(value:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        var escapedString:String = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/find_friends/" + escapedString + "/" + user.userId
        
        Alamofire.request(.GET, url, encoding: .URL)
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
    
    
    class func findNonFriends(value:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        var escapedString:String = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/find_non_friends/" + escapedString + "/" + user.userId
        
        Alamofire.request(.GET, url, encoding: .URL)
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
    
    
    
    class func declineFriendRequest(userId:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/decline_friend_request"
        let data = ["userId": userId,"publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
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
    
    
    
    class func acceptFriendRequest(userId:String, resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/accept_friend_request"
        let data = ["userId": userId,"publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]
        
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
    
    class func friendsRequestedByYou(resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/pending_friends_you_sent"
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

    class func acceptedFriends(resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/all"
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
    
    
    
    class func friendsRequestedByThem(resultJSON:(JSON) -> Void) -> Void {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/pending_friends_they_sent"
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

    class func addFriend(friendUserId:String, resultJSON:(JSON) -> Void) -> Void {

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var url:String = ProjectConstants.ApiBaseUrl.value + "/friend/add"
        let data = ["friendUserId": friendUserId, "publicKey" : user.publicKey, "encryptedSession": user.encryptedSession, "sessionHash": user.sessionHash]

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
        
        var url:String = ProjectConstants.ApiBaseUrl.value + "/add"
        let postEndpoint: String = "http://192.168.99.100:8080/user"
        //let postEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1"

        Alamofire.request(.GET, postEndpoint, encoding: .URL)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let post = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    print("The post is: " + post.description)
                    
                    /*
                    if let title = post["title"].string {
                        // to access a field:
                        print("The title is: " + title)
                    } else {
                        print("error parsing /posts/1")
                    }*/
                }
        }
        
    }
    
    
    
}