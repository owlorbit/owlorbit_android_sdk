//
//  MessageModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/3/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

import CoreData
import SwiftDate

@objc(MessageCoreModel)
class MessageCoreModel : NSManagedObject {
    
    @NSManaged var messageId:String
    @NSManaged var userId:String
    @NSManaged var roomId:String
    @NSManaged var message:String
    @NSManaged var messageType:String
    @NSManaged var imageLink:String
    @NSManaged var active:Bool
    @NSManaged var created:NSDate
    
    
    @NSManaged var senderDisplayName:String
    
    
    
    class func insertFromMessageModel(message:MessageModel){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "MessageCoreModel")
        let entity = NSEntityDescription.entityForName("MessageCoreModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = MessageCoreModel.getById(message.messageId())

        obj.messageId = message.messageId()
        obj.senderDisplayName = message.senderDisplayName()
        obj.userId = message.senderId()
        obj.roomId = message.roomId()
        obj.message = message.text()
        obj.messageType = "Text"
        obj.imageLink = ""
        obj.active = true
        obj.created = message.date()

        MessageCoreModel.insert(obj)
    }

    class func getByRoomId(roomId:String)->[MessageCoreModel]{

        let entity = NSEntityDescription.entityForName("MessageCoreModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "roomId == %@", roomId)

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "MessageCoreModel")
        fetchRequest.predicate = resultPredicate
            

        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [MessageCoreModel]
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                return fetchResults!
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return [];
    }
    
    class func doesMessageExist(roomId:String, userId:String, created:NSDate)->Bool{

        let entity = NSEntityDescription.entityForName("MessageCoreModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        //let resultPredicate = NSPredicate(format: "(roomId == %@) AND (userId == %@) AND (created == %@)", roomId, userId, created)
        
        
        let resultPredicate = NSPredicate(format: "created <= %@ AND created >= %@", created.add(years: nil, months:nil, weekOfYear: nil, days: nil, hours: nil, minutes: nil, seconds: 1, nanoseconds: nil),
        
        created.add(years: nil, months:nil, weekOfYear: nil, days: nil, hours: nil, minutes: nil, seconds: -1, nanoseconds: nil)
        )

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "MessageCoreModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [MessageCoreModel]
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                print("found result...")
                return true;
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return false;
    }
    
    
    
    class func getById(id:String)->MessageCoreModel{

        let entity = NSEntityDescription.entityForName("MessageCoreModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        if(id.isEmpty){
            return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! MessageCoreModel;
        }

        let resultPredicate = NSPredicate(format: "messageId == %@", id)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "MessageCoreModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [MessageCoreModel]
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                if let obj = fetchResults{
                    return obj[0]
                }
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! MessageCoreModel;
    }
    
    
    class func insert(userData : MessageCoreModel){
        
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
}