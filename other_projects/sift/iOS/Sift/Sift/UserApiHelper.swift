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

class UserApiHelper{

    class func createUser(user:RegistrationUser, resultJSON:(JSON) -> Void) -> Void {
        
        var url:String = ProjectConstants.ApiBaseUrl.value + "/user/add"
        let data = ["email": user.email, "first_name" : user.firstName, "last_name" : user.lastName, "phone_number":user.phoneNumber, "password" : user.password]

        Alamofire.request(.POST, url, parameters: data, encoding: .URL)
        .responseJSON { response in

            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /user/add \(response)")
                print(response.result.error!)
                return
            }
            
            if let value: AnyObject = response.result.value {
                // handle the results as JSON, without a bunch of nested if loops
                let post = JSON(value)
                print("The post is: " + post.description)
                resultJSON(post)
                //post["title"].string
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