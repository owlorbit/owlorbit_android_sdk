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
        
        var updatedNav = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.chatRoomTitle = "test"
        
        ///RIGHT HERE>
        vc.roomId = roomId  //check the room....
        vc.hidesBottomBarWhenPushed = true
        updatedNav.pushViewController(vc, animated: false )
        
        var chatView:ChatTextMessageViewController = ChatTextMessageViewController();
        chatView.roomId = roomId;
        updatedNav.pushViewController(chatView, animated: true)
        
        print("updated nav \(vc.classForCoder)")
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
        
        var updatedNav = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.chatRoomTitle = "test"
        
        ///RIGHT HERE>
        vc.roomId = roomId  //check the room....
        vc.hidesBottomBarWhenPushed = true
        updatedNav.pushViewController(vc, animated: false )
        
    }
    
    
    class func createPopupMessage(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject]){
   
        if let apsObj = userInfo["aps"] as? Dictionary<String, AnyObject> {

            if(ApplicationManager.isLoggedIn){
                
                var messageType:String = userInfo["message_type"] as! String
                
                
                if(messageType == "text"){
                    processTextNotification(appDelegate, userInfo: userInfo, apsObj: apsObj)
                }else if(messageType == "meetup"){
                    processMeetupNotification(appDelegate, userInfo: userInfo, apsObj: apsObj)
                }

            }else{
                appDelegate.pendingNotification = userInfo
                //AlertHelper.createPopupMessage("COME ONNN", title: "")
                
            }
            
        }

    }
    
    
    class func processMeetupNotification(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject> ){
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

        if appDelegate.window!.rootViewController is UICustomTabBarController {
            //do something if it's an instance of that class
            print("this isn't real")
            var controllers =  ((appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
            var navController = (appDelegate.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
            //if controllers.last?.classForCoder is
            
            if controllers.last is DashboardViewController{
                JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                
                otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
                
            }else if controllers.last is MapRadialViewController{
               print("map")
               appDelegate.pendingNotification = nil
               otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
                
            }else if controllers.last is ChatTextMessageViewController{
                appDelegate.pendingNotification = nil
                print("text")
                otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
                
            }else{
                appDelegate.pendingNotification = nil
                otherScreenMethodTriggerMap(appDelegate, title:"", body: message, roomId: roomId, userId:userId)
            }
            
            print(controllers.last?.classForCoder)
        }else{
            
            //look user in
            print("this is life")
        }
    }
    
    
    class func processTextNotification(appDelegate:AppDelegate, userInfo: [NSObject : AnyObject], apsObj:Dictionary<String, AnyObject> ){
        
        
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
                appDelegate.pendingNotification = nil
                otherScreenMethodTrigger(appDelegate, title:"\(firstName) says:", body: message, roomId: roomId, userId:userId)
            }
            
            print(controllers.last?.classForCoder)
        }else{
            
            //look user in
            print("this is life")
        }
    }
}
