//
//  RoomManagedModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/13/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


@objc(RoomManagedModel)
class RoomManagedModel: NSManagedObject {

    @NSManaged var userId:String
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var roomId:String
    @NSManaged var roomName:String
    @NSManaged var attributes:RoomAttributeManagedModel
    @NSManaged var lastMessage:String
    @NSManaged var avatarOriginal:String
    @NSManaged var timestamp:String
    

    class func initWithJson(json:JSON)->RoomManagedModel{

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = RoomManagedModel.getById(json["room_id"].string!)

        if(obj == nil){
            obj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! RoomManagedModel
        }

        obj!.roomId = json["room_id"].string!
        obj!.userId = json["user_id"].string!
        obj!.firstName = json["first_name"].string!
        obj!.lastName = json["last_name"].string!
        obj!.roomName = (json["room_name"]) ? json["room_name"].string! : ""
        obj!.lastMessage = (json["message"].error == nil) ? json["message"].string! : ""
        obj!.timestamp = (json["created"].error == nil) ? json["created"].string! : ""

        ApplicationManager.shareCoreDataInstance.saveContext()
        return obj!;
    }
    
    class func setRoomAttribute(roomId:String, roomAttribute:RoomAttributeManagedModel)->RoomManagedModel{
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")

        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = RoomManagedModel.getById(roomId)
        
        obj!.attributes = roomAttribute
        
        ApplicationManager.shareCoreDataInstance.saveContext()
        return obj!;
    }
    
    
    class func getAll()->[RoomManagedModel]{
        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [RoomManagedModel]
            
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                return fetchResults!
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return []
    }
    
    class func getById(roomId:String)->RoomManagedModel?{
        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "roomId == %@", roomId)

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [RoomManagedModel]

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

        return nil
        /*var obj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! RoomManagedModel
        return obj*/
    }
}
