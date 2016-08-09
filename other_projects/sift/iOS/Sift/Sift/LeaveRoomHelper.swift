//
//  LeaveRoomHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/20/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeaveRoomHelper {

    class func removeRoom(existingRoomsJSON:SwiftyJSON.JSON){

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;

        //loop through context..
        for roomManagedModel: RoomManagedModel in RoomManagedModel.getAll() {


            var containsUser:Bool = false
            for (key,subJson):(String, SwiftyJSON.JSON) in existingRoomsJSON {

                var roomId:String = subJson["room_id"].string!
                
                if(roomId == roomManagedModel.roomId){
                    containsUser = true
                }
            }
            
            if(!containsUser){
                do {
                    coreDataHelper.managedObjectContext.deleteObject(roomManagedModel)
                    try coreDataHelper.managedObjectContext.save()
                }catch{
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    
    class func removeRoomById(roomId:String){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        
        //loop through context..
        for roomManagedModel: RoomManagedModel in RoomManagedModel.getAll() {
            
            
            var containsUser:Bool = false
         
            if(roomId == roomManagedModel.roomId){
                containsUser = true
            }
            
            if(containsUser){
                do {
                    coreDataHelper.managedObjectContext.deleteObject(roomManagedModel)
                    try coreDataHelper.managedObjectContext.save()
                }catch{
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
}