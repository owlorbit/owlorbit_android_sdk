//
//  UserManagedModel.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/7/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

@objc(UserManagedModel)
class UserManagedModel: NSManagedObject {

    
    @NSManaged var accountType:String
    @NSManaged var active:Bool
    @NSManaged var avatarOriginal:String
    
    @NSManaged var email:String
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var phoneNumber:String
    
    @NSManaged var id:String

    /*
    class func insertFromJSON(serverReturnedData:JSON){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "UserManagedModel")
        let entity = NSEntityDescription.entityForName("UserManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var newUser = UserManagedModel.getById(serverReturnedData["id"].string!)
        
        if(newUser == nil){
            newUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! UserManagedModel
        }

        print("debug everything: \(serverReturnedData)")
        newUser!.id = (serverReturnedData["id"].error == nil) ? serverReturnedData["id"].string! : ""
        newUser!.accountType = (serverReturnedData["account_type"].error == nil) ? serverReturnedData["account_type"].string! : ""
        
        newUser!.email = (serverReturnedData["email"].error == nil) ? serverReturnedData["email"].string! : ""
        newUser!.firstName = (serverReturnedData["first_name"].error == nil) ? serverReturnedData["first_name"].string! : ""
        newUser!.lastName = (serverReturnedData["last_name"].error == nil) ? serverReturnedData["last_name"].string! : ""
        newUser!.phoneNumber = (serverReturnedData["phone_number"].error == nil) ? serverReturnedData["phone_number"].string! : ""

        newUser!.avatarOriginal = (serverReturnedData["avatar_original"].error == nil && (serverReturnedData["avatar_original"].string! as? String) != nil) ? serverReturnedData["avatar_original"].string! : ""
        UserManagedModel.insert(newUser!)
    }
    
    class func getById(id:String)->UserManagedModel?{
        let entity = NSEntityDescription.entityForName("UserManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        let resultPredicate = NSPredicate(format: "id == %@", id)
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "UserManagedModel")
        fetchRequest.predicate = resultPredicate
        
        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [UserManagedModel]
            
            if (!fetchResults!.isEmpty && fetchResults?.count > 0) {
                if let userManagedData = fetchResults{
                    return userManagedData[0]
                }
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return nil
    }
    
    class func insert(userData : UserManagedModel){
        
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
    }*/
}
