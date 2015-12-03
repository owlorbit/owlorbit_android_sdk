//
//  PersonalUserModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

@objc(PersonalUserModel)
class PersonalUserModel : NSManagedObject {
    
    @NSManaged var userId:String
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var email:String
    @NSManaged var phoneNumber:String
    @NSManaged var password:String

    @NSManaged var deviceId:String
    @NSManaged var encryptedSession:String
    @NSManaged var sessionHash:String
    
    @NSManaged var publicKey:String
    @NSManaged var privateKey:String
    @NSManaged var sessionToken:String
    
    @NSManaged var avatarOriginal:String

    class func getAll(managedObjectContext:NSManagedObjectContext)-> [PersonalUserModel]? {
        let fetchRequest = NSFetchRequest(entityName: "PersonalUserModel")

        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [PersonalUserModel]
            return fetchResults
        } catch let fetchError as NSError {
            print("fetch error: \(fetchError.localizedDescription)")
            return nil
        }
    }

    class func removeAll(){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "PersonalUserModel")

        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [PersonalUserModel]
            
            if let users = fetchResults{
                for user:PersonalUserModel in users{
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
    
    class func get() -> [PersonalUserModel]{
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "PersonalUserModel")

        do {
            let fetchResults = try coreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as? [PersonalUserModel]
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

    class func updateUserFromLogin(email:String, password:String, serverReturnedData:JSON){
        
        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance
        let fetchRequest = NSFetchRequest(entityName: "PersonalUserModel")
        //let entity = NSEntityDescription.entityForName("PersonalUserModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)

        if(PersonalUserModel.get().count > 0){
            var currentUser = PersonalUserModel.get()[0] as PersonalUserModel;
            
            currentUser.email = email
            currentUser.password = password
            currentUser.userId = serverReturnedData["userId"].string!
            currentUser.publicKey = serverReturnedData["publicKey"].string!
            currentUser.privateKey = serverReturnedData["privateKey"].string!
            currentUser.sessionToken = serverReturnedData["sessionToken"].string!
            currentUser.avatarOriginal = (serverReturnedData["avatar_original"].error == nil) ? serverReturnedData["avatar_original"].string! : ""
            
            currentUser.sessionHash = EncryptUtil.sha256(currentUser.sessionToken.dataUsingEncoding(NSUTF8StringEncoding)!)
            currentUser.encryptedSession = EncryptUtil.encryptSessionToken(currentUser.sessionToken, publicKey: currentUser.publicKey, privateKey: currentUser.privateKey)
            
        }else{
            var currentUser = RegistrationUser()
            currentUser.firstName = serverReturnedData["firstName"].string!
            currentUser.lastName = serverReturnedData["lastName"].string!
            currentUser.email = email
            currentUser.phoneNumber = serverReturnedData["phoneNumber"].string!
            currentUser.password = password

            PersonalUserModel.insertFromRegistration(currentUser, serverReturnedData: serverReturnedData)
        }

        PersonalUserModel.save()
    }
    
    class func insertFromRegistration(userData : RegistrationUser, serverReturnedData:JSON){

        let coreDataHelper:CoreDataHelper = CoreDataHelper();
        PersonalUserModel.removeAll()
        let fetchRequest = NSFetchRequest(entityName: "PersonalUserModel")
        let entity = NSEntityDescription.entityForName("PersonalUserModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var newUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext) as! PersonalUserModel
        
        newUser.email = userData.email
        newUser.firstName = userData.firstName
        newUser.lastName = userData.lastName
        newUser.phoneNumber = userData.phoneNumber
        newUser.password = userData.password

        newUser.userId = serverReturnedData["userId"].string!
        newUser.publicKey = serverReturnedData["publicKey"].string!
        newUser.privateKey = serverReturnedData["privateKey"].string!
        newUser.sessionToken = serverReturnedData["sessionToken"].string!
        newUser.sessionHash = EncryptUtil.sha256(newUser.sessionToken.dataUsingEncoding(NSUTF8StringEncoding)!)
        newUser.encryptedSession = EncryptUtil.encryptSessionToken(newUser.sessionToken, publicKey: newUser.publicKey, privateKey: newUser.privateKey)

        PersonalUserModel.insert(newUser)
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
    
    class func insert(userData : PersonalUserModel){

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