//
//  InfoAPI.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/13/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class InfoApiHelper{
    
    class func getServerInfo(resultJSON:(JSON) -> Void, error:(String)->Void) -> Void {
        
        var url:String = ProjectConstants.ApiBaseUrl.value + "/info/server"
        print(url)
        Alamofire.request(.GET, url, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    let json = String(data: response.data!, encoding: NSUTF8StringEncoding)
                    print("Failure Response: \(json)")
                    error(response.result.description)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let post = JSON(value)
                    resultJSON(post)
                }
        }
    }
    
    
}