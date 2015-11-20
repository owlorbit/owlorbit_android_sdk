//
//  UserModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import CoreData

@objc(UserModel)
class UserModel : NSManagedObject {
    
    @NSManaged var userId:String
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var email:String
    @NSManaged var phoneNumber:String
    @NSManaged var password:String

    @NSManaged var deviceId:String
    @NSManaged var encryptedSession:String
    @NSManaged var sessionHash:String

    class func getAll(managedObjectContext:NSManagedObjectContext)-> [UserModel]? {
        let fetchRequest = NSFetchRequest(entityName: "UserModel")

        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [UserModel]
            return fetchResults
        } catch let fetchError as NSError {
            print("fetch error: \(fetchError.localizedDescription)")
            return nil
        }
    }

    class func remove(){
        
        let coreDataHelper:CoreDataHelper = CoreDataHelper();
        let fetchRequest = NSFetchRequest(entityName: "UserModel")

        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [UserModel]
            
            if let users = fetchResults{
                for user:UserModel in users{
                    coreDataHelper.managedObjectContext.deleteObject(user)
                    try coreDataHelper.managedObjectContext.save()
                }
            }
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    class func get() -> [UserModel]{
        
        let coreDataHelper:CoreDataHelper = CoreDataHelper();
        let fetchRequest = NSFetchRequest(entityName: "UserModel")

        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [UserModel]
            if let users = fetchResults{
                return users
            }
            return [];
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    class func insertFromRegistration(userData : RegistrationUser){
        
        //userData
        //UserModel.remove()

        let coreDataHelper:CoreDataHelper = CoreDataHelper();
        let fetchRequest = NSFetchRequest(entityName: "UserModel")
        let entity = NSEntityDescription.entityForName("UserModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var newUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! UserModel
        
        newUser.email = userData.email
        newUser.firstName = userData.firstName
        newUser.lastName = userData.lastName
        newUser.phoneNumber = userData.phoneNumber
        newUser.password = userData.password
        
        print(">> \(userData.email)")
        print("<< \(newUser.email)")


        UserModel.insert(newUser)
    }
    
    class func insert(userData : UserModel){

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