//
//  AppDelegate.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/4/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import ALThreeCircleSpinner
import CoreData
import Parse

import JSQMessagesViewController
import SwiftDate
import SwiftyJSON

import LNRSimpleNotifications
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationManager = LNRNotificationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        //setApplicationId(applicationId: String, clientKey: String)
        
        
        notificationManager.notificationsPosition = LNRNotificationPosition.Top
        notificationManager.notificationsBackgroundColor = UIColor.whiteColor()
        notificationManager.notificationsTitleTextColor = UIColor.blackColor()
        notificationManager.notificationsBodyTextColor = UIColor.darkGrayColor()
        notificationManager.notificationsSeperatorColor = UIColor.grayColor()
        notificationManager.notificationsIcon = UIImage(named: "owl_orbit")
        
        var alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
            notificationManager.notificationSound = mySound
        }
        
        
        Parse.setApplicationId("mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN",
            clientKey: "fURuXJR5xjG7p2B7AqdKANUJVwb9pko4y4n3zi7o")
        if application.applicationState != UIApplicationState.Background {

            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }

        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.whiteColor()
            
            var viewController = UINavigationController(rootViewController: PreloadHomeViewController())
            //window.rootViewController = LoginViewController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()

        var deviceStr:String = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
        
        ApplicationManager.parseDeviceId = deviceStr
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("first case.... \(userInfo)")

        processPushNotification(userInfo)
        //log the user in../
        
        /*PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }*/
    }
    
    
    func methodThatTriggersNotification(title: String, body: String, roomId: String, userId:String) {
        
        notificationManager.showNotification(title, body: body, callback: { () -> Void in
            self.notificationManager.dismissActiveNotification({ () -> Void in
                print("Notification dismissed: \(roomId)")
            })
        })
    }

    
    
    func processPushNotification(userInfo: [NSObject : AnyObject]){
        //first check to see if message is already in coredata...

        //this is only handling if the app is minimized or closed...

        
        if let apsObj = userInfo["aps"] as? Dictionary<String, AnyObject> {
            

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
                var messageCore : MessageModel = MessageModel(messageId: messageId, senderId: userId, senderDisplayName: firstName, isMediaMessage: false, date: dateConverted, roomId: roomId , text: message)
                MessageCoreModel.insertFromMessageModel(messageCore)
            }
            
            
            //only if you are logged in.
            //now load the room then launch
            //if the room is already launched then... uh just call a reload
            //check what the top most view controller is right now...
            if(ApplicationManager.isLoggedIn){
                //((UINavigationController*)appDelegate.window.rootViewController).visibleViewController;
                
                //(appDelegate.window.rootViewController as! UINavigationController).visibleViewController
                //print("fucking deep end: \(   (self.window?.rootViewController as! UICustomTabBarController).visibleViewController?.description      )")
                
                if self.window!.rootViewController is UICustomTabBarController {
                    //do something if it's an instance of that class
                    print("this isn't real")
                    var controllers =  ((self.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController).viewControllers
                    var navController = (self.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
                    //if controllers.last?.classForCoder is
                    
                    if controllers.last is DashboardViewController{
                        print("dashboard.. make text bold.. or add")
                    }else if controllers.last is ChatThreadViewController{
                        print("map")
                        
                        /*
                        var mapVC = controllers.last as! ChatThreadViewController

                        //make sure roomId is the room.
                        var updatedNav = (self.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
                        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
                     
                        var chatView:ChatTextMessageViewController = ChatTextMessageViewController();
                        chatView.roomId = roomId;
                        updatedNav.pushViewController(chatView, animated: true)
                        */
                        methodThatTriggersNotification("\(firstName) says:", body: message, roomId: roomId, userId:userId)
                        
                        
                    }else if controllers.last is ChatTextMessageViewController{
                        print("text")

                        //loadInitMessages
                        var textVC = controllers.last as! ChatTextMessageViewController
                        
                        if(textVC.roomId != roomId){
                            print("change room id \(roomId)")
                            //textVC.roomId = roomId
                            methodThatTriggersNotification("\(firstName) says:", body: message, roomId: roomId, userId:userId)
                        }
                        
                        textVC.loadInitMessages()
                        
                        
                    }else{
                        
                        methodThatTriggersNotification("\(firstName) says:", body: message, roomId: roomId, userId:userId)
                        /*
                        let tabBarController = UICustomTabBarController()
                        self.window!.rootViewController = tabBarController

                        var updatedNav = (self.window!.rootViewController as! UICustomTabBarController).selectedViewController as! UINavigationController
                        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
                        vc.chatRoomTitle = "test"
                        
                        ///RIGHT HERE>
                        vc.roomId = roomId  //check the room....
                        vc.hidesBottomBarWhenPushed = true
                        updatedNav.pushViewController(vc, animated: false )
                        
                        var chatView:ChatTextMessageViewController = ChatTextMessageViewController();
                        chatView.roomId = roomId;
                        updatedNav.pushViewController(chatView, animated: true)

                        print("updated nav \(vc.classForCoder)")*/
                    }

                    print(controllers.last?.classForCoder)
                }else{
                    
                    //look user in
                    print("this is life")
                }
            }
            
        }
    }

    func sendLocations(){
        //check if you're logged in...
    }

    func setRootViewController(viewController:UIViewController){
    }

    func setupLoggedOutViewController(){
        var viewController = UINavigationController(rootViewController: PreloadHomeViewController())
        
        //let tabBarController = UICustomTabBarController()
        //self.window!.rootViewController = tabBarController
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.rootViewController = viewController
        }
        
        UIView.transitionWithView(self.window!, duration: 0.2,
            options:.TransitionCrossDissolve, animations: {
                self.window!.makeKeyAndVisible()
            },
        completion: nil)
        
    }
    
    
    func setupLoggedInViewController(){
        
        let tabBarController = UICustomTabBarController()
        self.window!.rootViewController = tabBarController

        UIView.transitionWithView(self.window!, duration: 0.2,
            options:.TransitionCrossDissolve, animations: {
                self.window!.makeKeyAndVisible()
            }, completion: nil)

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.timnuwin.Sift" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Sift", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

