//
//  RoomAttributeManagedModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/13/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//


import Foundation
import CoreData
import SwiftyJSON

@objc(RoomAttributeManagedModel)
class RoomAttributeManagedModel: NSManagedObject {

    @NSManaged var users:NSMutableSet
    @NSManaged var name:String
    @NSManaged var roomId:String
    
    ////
    
    class func initWithJson(json:JSON, roomId:String)->RoomAttributeManagedModel{
        var roomName:String = ""
        var usersArr:NSMutableSet = []
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomAttributeManagedModel")
        
        let entity = NSEntityDescription.entityForName("RoomAttributeManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = RoomAttributeManagedModel.getById(roomId)
        
        
        for (key,subJson):(String, SwiftyJSON.JSON) in json["room_attributes"] {
            var genericUser:GenericUserManagedModel = GenericUserManagedModel.initWithJson(subJson)
            usersArr.addObject(genericUser);
            roomName += genericUser.firstName + ", "
        }
        roomName.removeRange(roomName.endIndex.advancedBy(-2)..<roomName.endIndex)
        
        obj.roomId = roomId
        obj.name = roomName
        obj.users = usersArr
        
        ApplicationManager.shareCoreDataInstance.saveContext()
        return obj;
    }
    
    class func getById(roomId:String)->RoomAttributeManagedModel{
        let entity = NSEntityDescription.entityForName("RoomAttributeManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "roomId == %@", roomId)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomAttributeManagedModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [RoomAttributeManagedModel]
            
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                if let roomManagedData = fetchResults{
                    return roomManagedData[0]
                }
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        var obj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! RoomAttributeManagedModel
        return obj
    }

    
}
