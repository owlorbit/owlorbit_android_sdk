//
//  ChatHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/5/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation

class MapHelper{
    
 
    class func doesUserExist(annotations:NSMutableArray, userModel:GenericUserManagedModel) -> Bool {

        do {
            for val in annotations{
                //make sure not nil..
                if val is UserPointAnnotation{
                    var userPointAnnotation:UserPointAnnotation = val as! UserPointAnnotation

                    if(userPointAnnotation.userModel.userId == userModel.userId){
                        return true
                    }
                }
            }
        }catch _ {
            print("test")
        }
        
        return false
    }
    
    
    class func doesUserLocationExist(annotations:NSMutableArray, userModel:UserLocationModel) -> Bool {
        
        do {
            for val in annotations{
                //make sure not nil..
                if val is UserPointAnnotation{
                    var userPointAnnotation:UserLocationPointAnnotation = val as! UserLocationPointAnnotation
                    
                    if(userPointAnnotation.userLocationModel.userId == userModel.userId &&
                        userPointAnnotation.userLocationModel.deviceId == userModel.deviceId
                        ){
                        return true
                    }
                }
            }
        }catch _ {
            print("test")
        }
        
        return false
    }
    
    
    class func addAnnotation(){
        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(appDelegate.locationManager.location == nil){return}
        let annotation = CustomMeetupPin()
        annotation.coordinate = appDelegate.locationManager.location!.coordinate // your location here
        annotation.title = "My Title"
        annotation.subtitle = "My Subtitle"
        self.mapView.addAnnotation(annotation)*/
    }
}