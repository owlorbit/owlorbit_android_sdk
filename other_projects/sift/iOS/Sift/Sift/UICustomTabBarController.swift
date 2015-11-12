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

        let settingsViewController = SettingsViewController()
        var settingsIcon : UIImage = UIImage(named:"settings")!
        var settingsNavController = UINavigationController(rootViewController: settingsViewController)
        settingsNavController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: settingsIcon,
            tag: 2);
        
        
        
        let controllers = [homeNavController, settingsNavController]
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
