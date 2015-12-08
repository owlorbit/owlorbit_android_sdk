//
//  MessageModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/3/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

import CoreData

@objc(MessageCoreModel)
class MessageCoreModel : NSManagedObject {
    
    @NSManaged var messageId:String
    @NSManaged var userId:String
    @NSManaged var roomId:String
    @NSManaged var message:String
    @NSManaged var messageType:String
    @NSManaged var imageLink:String
    @NSManaged var active:String
    @NSManaged var created:String
    
    

}