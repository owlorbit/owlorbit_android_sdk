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
                var userPointAnnotation:UserPointAnnotation = val as! UserPointAnnotation
                
                if(userPointAnnotation.userModel.userId == userModel.userId){
                    return true
                }
            }
        }catch _ {
            print("test")
        }
        
        return false
    }
}