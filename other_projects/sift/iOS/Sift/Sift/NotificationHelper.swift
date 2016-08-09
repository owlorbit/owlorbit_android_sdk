//
//  NotificationHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/27/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import CoreData
import Parse

import JSQMessagesViewController
import SwiftDate
import SwiftyJSON


class NotificationHelper{
    
    
    class func otherScreenMethodTrigger(appDelegate:AppDelegate, title: String, body: String, roomId: String, userId:String) {

        appDelegate.notificationManager.showNotification(title, body: body, callback: { () -> Void in
            appDelegate.notificationManager.dismissActiveNotification({ () -> Void in
                loadFromOtherThanMapAndChatToChat(appDelegate, roomId: roomId)
            })
        })
    }

    class func loadFromOtherThanMapAndChatToChat(appDelegate:AppDelegate, roomId: String){
        let tabBarController = UICustomTabBarController()
        appDelegate.window!.rootViewController = tabBarController

        RoomApiHelper.getRoomManaged(roomId, resultJSON:{
            (JSON3) in
            
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON3["rooms"] {
                var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                
                print("ferrrp: \(subJson)");
                RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                    (JSON2) in
                    
                    RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                        (roomAttribute) in
                        
                        roomModel.attributes = roomAttribute
                        if(roomModel.attributes.users.count > 0){
                            roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                        }
                        
                        ApplicationManager.shareCoreDataInstance.saveContext()
                        var roomData:RoomManagedModel?  = RoomManagedModel.getById(roomModel.roomId)
                        
                       
                        if(!ApplicationManager.NOTIFICATION_LOCK_PUSH){
                            ApplicationManager.NOTIFICATION_LOCK_PUSH = true;
                            var updatedNav = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
                            let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                            vc.chatRoomTitle = roomModel.attributes.name
                            vc.roomId = roomModel.roomId
                            vc.hidesBottomBarWhenPushed = true
                            updatedNav.pushViewController(vc, animated: false )
                            
                            var chatView:ChatTextMessageViewController = ChatTextMessageViewController();
                            chatView.roomId = roomId;
                            updatedNav.pushViewController(chatView, animated: true)
                        }
                        
                        
                    })
                });
            }
        });
    }
    
    
    class func otherScreenMethodTriggerMap(appDelegate:AppDelegate, title: String, body: String, roomId: String, userId:String) {
        
        appDelegate.notificationManager.showNotification(title, body: body, callback: { () -> Void in
            appDelegate.notificationManager.dismissActiveNotification({ () -> Void in
                loadFromOtherThenMap(appDelegate, roomId: roomId)
            })
        })
    }
    
    
    
    class func loadFromOtherThenMap(appDelegate:AppDelegate, roomId: String){
        
        let tabBarController = UICustomTabBarController()
        appDelegate.window!.rootViewController = tabBarController
        
        RoomApiHelper.getRoomManaged(roomId, resultJSON:{
            (JSON3) in
            
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON3["rooms"] {
                var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                
                print("ferrrp: \(subJson)");
                RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                    (JSON2) in
                    
                    RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                        (roomAttribute) in
                        
                        roomModel.attributes = roomAttribute
                        if(roomModel.attributes.users.count > 0){
                            roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                        }
                        
                        ApplicationManager.shareCoreDataInstance.saveContext()
                        var roomData:RoomManagedModel?  = RoomManagedModel.getById(roomModel.roomId)
                        
                        
                        if(!ApplicationManager.NOTIFICATION_LOCK_PUSH){
                            ApplicationManager.NOTIFICATION_LOCK_PUSH = true;
                            var updatedNav = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
                            let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                            vc.chatRoomTitle = roomModel.attributes.name
                            vc.roomId = roomModel.roomId
                            vc.hidesBottomBarWhenPushed = true
                            updatedNav.pushViewController(vc, animated: false )
                        }
                    })
                });
            }
        });
    }
    
    class func createPopupMessage(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], applicationState: UIApplicationState){
   
        if let apsObj = userInfo["aps"] as? Dictionary<String, AnyObject> {

            if(ApplicationManager.isLoggedIn){
                
                var messageType:String = userInfo["message_type"] as! String
                
                
                if(messageType == "text"){
                    processTextNotification(appDelegate, userInfo: userInfo, apsObj: apsObj, applicationState:applicationState)
                }else if(messageType == "meetup" || messageType == "visibility"){
                    processMeetupNotification(appDelegate, userInfo: userInfo, apsObj: apsObj, applicationState:applicationState)
                }else if(messageType == "request_friend"){
                    processRequestFriendNotification(appDelegate, userInfo: userInfo, apsObj: apsObj, applicationState:applicationState)
                }else if(messageType == "accept_friend"){
                    processAcceptFriend(appDelegate, userInfo: userInfo, apsObj: apsObj, applicationState:applicationState)
                }else if(messageType == "decline_friend"){
                    processRejectFriend(appDelegate, userInfo: userInfo, apsObj: apsObj, applicationState:applicationState)
                }
            }else{
                appDelegate.pendingNotification = userInfo
                //AlertHelper.createPopupMessage("COME ONNN", title: "")
            }
        }
    }
    
    class func notifyFriendRequest(appDelegate:AppDelegate, title: String, body: String, userId:String) {
        
        appDelegate.notificationManager.showNotification(title, body: body, callback: { () -> Void in
            appDelegate.notificationManager.dismissActiveNotification({ () -> Void in
                loadRequestFriendTab(appDelegate)
            })
        })
    }
    
    class func loadRequestFriendTab(appDelegate:AppDelegate){
        
        let tabBarController = UICustomTabBarController()
        appDelegate.window!.rootViewController = tabBarController
        
        
        //if appDelegate.window!.rootViewController as? UICustomTabBarController != nil {
            var tababarController = appDelegate.window!.rootViewController as! UICustomTabBarController
            tababarController.selectedIndex = 2
        //}
        
    }
    
    
    class func notifyFriendAccept(appDelegate:AppDelegate, title: String, body: String, userId:String) {
        
        appDelegate.notificationManager.showNotification(title, body: body, callback: { () -> Void in
            appDelegate.notificationManager.dismissActiveNotification({ () -> Void in
                loadAcceptFriendTab(appDelegate)
            })
        })
    }

    class func loadAcceptFriendTab(appDelegate:AppDelegate){
        
        let tabBarController = UICustomTabBarController()
        appDelegate.window!.rootViewController = tabBarController

        if(!ApplicationManager.NOTIFICATION_LOCK_PUSH){
            ApplicationManager.NOTIFICATION_LOCK_PUSH = true;
            var updatedNav = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            
            
            
            
            
            
            let vc = WriteMessageViewController(nibName: "WriteMessageViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true;
            updatedNav.pushViewController(vc, animated: false )
        }
    }

    class func notifyFriendReject(appDelegate:AppDelegate, title: String, body: String, userId:String) {
        
        appDelegate.notificationManager.showNotification(title, body: body, callback: { () -> Void in
            appDelegate.notificationManager.dismissActiveNotification({ () -> Void in
                loadRejectFriendTab(appDelegate)
            })
        })
    }

    class func loadRejectFriendTab(appDelegate:AppDelegate){
        
        let tabBarController = UICustomTabBarController()
        appDelegate.window!.rootViewController = tabBarController

        //if appDelegate.window!.rootViewController as? UICustomTabBarController != nil {
        var tababarController = appDelegate.window!.rootViewController as! UICustomTabBarController
        tababarController.selectedIndex = 2
        

        var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
        
        if controllers.last is ManageRequestsViewController{
           var manageRequestController = controllers.last as! ManageRequestsViewController
            
            
        }
        
        //}
    }

    class func processRejectFriend(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject>, applicationState: UIApplicationState ){

        var alertMessage:String = apsObj["alert"] as! String
        var message:String = alertMessage
        var userId:String = userInfo["user_id"] as! String
        
        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            
            if applicationState == .Inactive {
                loadRejectFriendTab(appDelegate)
            }else{
                
                if controllers.last is ManageRequestsViewController{
                    notifyFriendReject(appDelegate, title:"", body: message, userId:userId)
                }else{
                    
                    if applicationState == .Inactive {
                        loadRejectFriendTab(appDelegate)
                    }else{
                        if(appDelegate.pendingNotification == nil){
                            notifyFriendReject(appDelegate, title:"", body: message, userId:userId)
                        }else{
                            loadRejectFriendTab(appDelegate)
                        }
                    }
                    appDelegate.pendingNotification = nil
                }
            }
            print(controllers.last?.classForCoder)
        }else{
            print("this is life")
        }
    }
    

    class func processAcceptFriend(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject>, applicationState: UIApplicationState ){
      
        
        var alertMessage:String = apsObj["alert"] as! String
        var message:String = alertMessage
        var userId:String = userInfo["user_id"] as! String
        
        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            print("this isn't real")
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController

            if applicationState == .Inactive {
                loadAcceptFriendTab(appDelegate)
            }else{
                
                if controllers.last is WriteMessageViewController{
                    JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                    
                    var vc = controllers.last as! WriteMessageViewController
                    vc.loadLists()
                    appDelegate.pendingNotification = nil
                }else{
                    
                    if applicationState == .Inactive {
                        loadAcceptFriendTab(appDelegate)
                    }else{
                        if(appDelegate.pendingNotification == nil){
                            notifyFriendAccept(appDelegate, title:"", body: message, userId:userId)
                        }else{
                            loadAcceptFriendTab(appDelegate)
                        }
                    }
                    appDelegate.pendingNotification = nil
                }
            }
            print(controllers.last?.classForCoder)
        }else{
            print("this is life")
        }
    }

    class func processRequestFriendNotification(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject>, applicationState: UIApplicationState ){
        var created:String = userInfo["created"] as! String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
        var dateConverted:NSDate = dateFormatter.dateFromString(created)!

        var alertMessage:String = apsObj["alert"] as! String
        var message:String = alertMessage
        var userId:String = userInfo["user_id"] as! String
        var firstName:String = userInfo["first_name"] as! String
        var messageId:String = userInfo["message_id"] as! String

        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            print("this isn't real")
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            //if controllers.last?.classForCoder is
            
            
            if applicationState == .Inactive {
                loadRequestFriendTab(appDelegate)
            }else{
            
                if controllers.last is ManageRequestsViewController{
                    JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                    
                    var vc = controllers.last as! ManageRequestsViewController
                    vc.loadLists()
                    appDelegate.pendingNotification = nil
                }else{

                    if applicationState == .Inactive {
                        loadRequestFriendTab(appDelegate)
                    }else{
                        if(appDelegate.pendingNotification == nil){
                            notifyFriendRequest(appDelegate, title:"", body: message, userId:userId)
                        }else{
                            loadRequestFriendTab(appDelegate)
                        }
                    }

                    appDelegate.pendingNotification = nil
                }
            }
            print(controllers.last?.classForCoder)
        }else{
            
            //look user in
            print("this is life")
        }
    }
    
    
    class func processMeetupNotification(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject>, applicationState: UIApplicationState ){
        var created:String = userInfo["created"] as! String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
        var dateConverted:NSDate = dateFormatter.dateFromString(created)!
        
        
        var alertMessage:String = apsObj["alert"] as! String
        var message:String = alertMessage
        
        var roomId:String = userInfo["room_id"] as! String
        var userId:String = userInfo["user_id"] as! String
        var firstName:String = userInfo["first_name"] as! String
        var messageId:String = userInfo["message_id"] as! String
        
        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            print("this isn't real")
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            //if controllers.last?.classForCoder is
            
            
            if applicationState == .Inactive {
                loadFromOtherThenMap(appDelegate, roomId: roomId)
            }else{
                
                if controllers.last is DashboardViewController{
                    JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                    
                    if(appDelegate.pendingNotification == nil){
                        otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
                    }else{
                        loadFromOtherThenMap(appDelegate, roomId: roomId)
                    }
                    
                    appDelegate.pendingNotification = nil
                }else if controllers.last is MapRadialViewController{
                    print("map")
                    appDelegate.pendingNotification = nil
                    otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
                }else{
                    appDelegate.pendingNotification = nil
                    
                    if applicationState == .Inactive {
                        loadFromOtherThenMap(appDelegate, roomId: roomId)
                    }else{
                        if(appDelegate.pendingNotification == nil){
                            otherScreenMethodTriggerMap(appDelegate, title:"\(firstName) says:", body: message, roomId: roomId, userId:userId)
                        }else{
                            loadFromOtherThenMap(appDelegate, roomId: roomId)
                        }
                    }
                    
                    appDelegate.pendingNotification = nil
                }
                
            }
            print(controllers.last?.classForCoder)
        }else{
            
            //look user in
            print("this is life")
        }
    }
    
    
    
    
    class func processTextNotification(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject>, applicationState: UIApplicationState ){
        
        
        var created:String = userInfo["created"] as! String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
        var dateConverted:NSDate = dateFormatter.dateFromString(created)!
        
        
        var alertMessage:String = apsObj["alert"] as! String
        var needle = "says:\n"
        let hayStackRange = alertMessage.rangeOfString(needle)
        let myRange = Range<String.Index>(start: hayStackRange!.endIndex, end: alertMessage.endIndex)
        var message:String = alertMessage.substringWithRange(myRange)
        
        var roomId:String = userInfo["room_id"] as! String
        var userId:String = userInfo["user_id"] as! String
        var firstName:String = userInfo["first_name"] as! String
        var messageId:String = userInfo["message_id"] as! String
        
        if(MessageCoreModel.doesMessageExist(roomId, userId: userId, created: dateConverted.inRegion(Region.defaultRegion()).UTCDate)){
            print("wat the actual")
        }else{
            //var messageCore : MessageModel = MessageModel(messageId: messageId, senderId: userId, senderDisplayName: firstName, isMediaMessage: false, date: dateConverted, roomId: roomId , text: message)
            //MessageCoreModel.insertFromMessageModel(messageCore)
        }
        
        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            print("this isn't real")
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            //if controllers.last?.classForCoder is
            
            
            if applicationState == .Inactive {
                loadFromOtherThanMapAndChatToChat(appDelegate, roomId: roomId)
            }else{
                if controllers.last is DashboardViewController{
                    JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                    
                    if(appDelegate.pendingNotification == nil){
                        var dashboardVC = controllers.last as! DashboardViewController
                        dashboardVC.makeTextBold(roomId, displayName:firstName, message:message)
                    }else{
                        appDelegate.pendingNotification = nil;
                        loadFromOtherThanMapAndChatToChat(appDelegate, roomId: roomId)
                    }
                    
                }else if controllers.last is MapRadialViewController{
                    print("map")
                    appDelegate.pendingNotification = nil
                    otherScreenMethodTrigger(appDelegate, title:"\(firstName) says:", body: message, roomId: roomId, userId:userId)
                    
                }else if controllers.last is ChatTextMessageViewController{
                    appDelegate.pendingNotification = nil
                    print("text")
                    
                    //loadInitMessages
                    var textVC = controllers.last as! ChatTextMessageViewController
                    if(textVC.roomId != roomId){
                        print("change room id \(roomId)")
                        //textVC.roomId = roomId
                        otherScreenMethodTrigger(appDelegate, title:"\(firstName) says:", body: message, roomId: roomId, userId:userId)
                    }
                    textVC.loadInitMessages()
                    
                }else{
                    
                    
                    if applicationState == .Inactive {
                        loadFromOtherThanMapAndChatToChat(appDelegate, roomId: roomId)
                        
                    }else{
                    
                        if(appDelegate.pendingNotification == nil){
                            otherScreenMethodTrigger(appDelegate, title:"\(firstName) says:", body: message, roomId: roomId, userId:userId)
                        }else{
                            loadFromOtherThanMapAndChatToChat(appDelegate, roomId: roomId)
                        }
                    }
                    
                    appDelegate.pendingNotification = nil
                }
            }
            
            print(controllers.last?.classForCoder)
        }else{
            
            //look user in
            print("this is life")
        }
    }
}
