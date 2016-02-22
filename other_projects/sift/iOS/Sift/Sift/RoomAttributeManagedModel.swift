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

    
    class func initWithJson(json:JSON, roomId:String, roomAttributeModel:(RoomAttributeManagedModel) -> Void){

        let coreDataHelper:CoreDataHelper = ApplicationManager.shareCoreDataInstance;
        let fetchRequest = NSFetchRequest(entityName: "RoomAttributeManagedModel")
        
        let entity = NSEntityDescription.entityForName("RoomAttributeManagedModel", inManagedObjectContext: ApplicationManager.shareCoreDataInstance.managedObjectContext)
        var obj = RoomAttributeManagedModel.getById(roomId)
        
        obj.roomId = roomId

        dispatch_async(dispatch_get_main_queue()) {
            RoomAttributeManagedModel.generateUserName(obj, json: json, doneLoading:{
                (doneLoading) in
                    if(doneLoading){
                        ApplicationManager.shareCoreDataInstance.saveContext()
                        roomAttributeModel(obj)
                    }
                }
            )
        }
    }
    
    class func generateUserName(obj:RoomAttributeManagedModel, json:JSON, doneLoading:(Bool) -> Void){
        var usersArr:NSMutableSet = []
        var roomName:String = ""
        var objIndex:Int = 0

        for (key,subJson):(String, SwiftyJSON.JSON) in json["room_attributes"] {
            
            
            GenericUserManagedModel.initWithJson(subJson, resultGenericUser:
                {
                    (genUser) in

                    objIndex++
                    var genericUser:GenericUserManagedModel = genUser
                    usersArr.addObject(genericUser);
                    roomName += genericUser.firstName + ", "
                    if(objIndex >= json["room_attributes"].count){
                        roomName.removeRange(roomName.endIndex.advancedBy(-2)..<roomName.endIndex)
                        obj.name = roomName
                        obj.users = usersArr
                        ApplicationManager.shareCoreDataInstance.saveContext()
                        doneLoading(true)
                    }
                }
            )
        }
        
        
        
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
