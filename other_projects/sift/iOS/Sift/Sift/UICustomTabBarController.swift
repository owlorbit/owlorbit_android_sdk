//
//  UICustomTabBarController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/11/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class UICustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let homeViewController = DashboardViewController()
        let homeIcon : UIImage = UIImage(named:"home")!
        var homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.tabBarItem = UITabBarItem(
            title: "Home",
            image: homeIcon,
            tag: 1);

        
        let friendRequestViewController = FriendRequestViewController()
        var friendsIcon : UIImage = UIImage(named:"email_icon")!
        var friendRequestNavController = UINavigationController(rootViewController: friendRequestViewController)
        friendRequestNavController.tabBarItem = UITabBarItem(
            title: "Discover",
            image: friendsIcon,
            tag: 2);
        
        
        let manageRequestsViewController = ManageRequestsViewController()
        var manageRequestsNavController = UINavigationController(rootViewController: manageRequestsViewController)
        manageRequestsNavController.tabBarItem = UITabBarItem(
            title: "Requests",
            image: UIImage(named:"request_icon")!,
            tag: 3);
        

        let settingsViewController = SettingsViewController()
        var settingsIcon : UIImage = UIImage(named:"settings")!
        var settingsNavController = UINavigationController(rootViewController: settingsViewController)
        settingsNavController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: settingsIcon,
            tag: 4);

        let notificationsViewController = NotificationsViewController()
        var notificationsIcon : UIImage = UIImage(named:"notification-icon")!
        var notificationsNavController = UINavigationController(rootViewController: notificationsViewController)
        notificationsNavController.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: notificationsIcon,
            tag: 5);

        let controllers = [homeNavController, friendRequestNavController, manageRequestsNavController, settingsNavController, notificationsNavController]
        self.viewControllers = controllers
        
        self.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
