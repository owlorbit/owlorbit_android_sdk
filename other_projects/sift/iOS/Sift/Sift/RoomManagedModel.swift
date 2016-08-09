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
import SwiftDate


@objc(RoomManagedModel)
class RoomManagedModel: NSManagedObject {

    @NSManaged var lastMessage:String
    @NSManaged var avatarOriginal:String
    @NSManaged var lastDisplayName:String
    @NSManaged var roomId:String
    @NSManaged var userId:String
    @NSManaged var roomName:String

    @NSManaged var lastMessageTimestamp:NSDate?
    @NSManaged var created:NSDate?
    @NSManaged var activeTimestamp:NSDate?

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
        obj!.avatarOriginal = json["avatar_original"].string!
        obj!.roomName = json["room_name"].string!

        
        if(json["last_display_name"].string != nil){
            obj!.lastDisplayName = (json["last_display_name"].error == nil) ? json["last_display_name"].string! : ""
        }
        
        if(json["last_message"].string != nil){
            obj!.lastMessage = (json["last_message"].error == nil) ? json["last_message"].string! : ""
        }

        if(json["last_message_timestamp"].string != nil){
            var created:String = json["last_message_timestamp"].string!
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(created)!
            obj!.lastMessageTimestamp = dateConverted.inRegion(Region.defaultRegion()).UTCDate
        }
        
        if(json["created"].string != nil){
            var created:String = json["created"].string!
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(created)!
            obj!.lastMessageTimestamp = dateConverted.inRegion(Region.defaultRegion()).UTCDate
        }
        
        if(json["active_timestamp"].string != nil){
            var created:String = json["active_timestamp"].string!
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(created)!
            obj!.lastMessageTimestamp = dateConverted.inRegion(Region.defaultRegion()).UTCDate
        }


        ApplicationManager.shareCoreDataInstance.saveContext()
        return obj!;
    }

    
    class func getUsersAndGroup(userId:String)->[RoomManagedModel]{

        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        let resultPredicate = NSPredicate(format: "userId != %@", userId)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimestamp", ascending: false)]
        fetchRequest.predicate = resultPredicate
        
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

    class func getAll()->[RoomManagedModel]{
        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimestamp", ascending: false)]
        
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
    
    
    class func save(){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        if coreDataHelper.managedObjectContext.hasChanges {
            do {
                print("changes!")
                try coreDataHelper.managedObjectContext.save()
                print("save!")
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }else{
            print("no changes!")
        }
    }

    
    class func removeAll(){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomManagedModel")
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [RoomManagedModel]
            
            if let rooms = fetchResults{
                for room:RoomManagedModel in rooms{
                    coreDataHelper.managedObjectContext.deleteObject(room)
                    try coreDataHelper.managedObjectContext.save()
                }
            }
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    
    
    class func getByRoomIdAndUserId(roomId:String, userId:String)->RoomManagedModel?{
        let entity = NSEntityDescription.entityForName("RoomManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "roomId == %@ AND userId == %@", roomId, userId)
        
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
