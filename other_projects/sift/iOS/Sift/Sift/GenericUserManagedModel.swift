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


@objc(GenericUserManagedModel)
class GenericUserManagedModel: NSManagedObject {

    @NSManaged var userId:String
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var email:String
    @NSManaged var phoneNumber:String
    @NSManaged var accountType:String
    @NSManaged var avatarOriginal:String
    @NSManaged var avatarImg:UIImage

    class func initWithJson(json:JSON)->GenericUserManagedModel{
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "GenericUserManagedModel")
        
        let entity = NSEntityDescription.entityForName("GenericUserManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = GenericUserManagedModel.getById(json["room_id"].string!)

        obj.userId = (json["id"].error == nil) ? json["id"].string! : ""
        obj.firstName = (json["first_name"].error == nil) ? json["first_name"].string! : ""
        obj.lastName = (json["last_name"].error == nil) ? json["last_name"].string! : ""
        obj.email = (json["email"].error == nil) ? json["email"].string! : ""
        obj.phoneNumber = (json["phone_number"].error == nil) ? json["phone_number"].string! : ""
        obj.accountType = (json["account_type"].error == nil) ? json["account_type"].string! : ""
        obj.avatarOriginal = (json["avatar_original"].error == nil) ? json["avatar_original"].string! : ""
        
        
        ApplicationManager.shareCoreDataInstance.saveContext()
        return obj;
    }
    
    class func getById(roomId:String)->GenericUserManagedModel{
        let entity = NSEntityDescription.entityForName("GenericUserManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "userId == %@", roomId)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "GenericUserManagedModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [GenericUserManagedModel]
            
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
        
        var obj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! GenericUserManagedModel
        return obj
    }
}
