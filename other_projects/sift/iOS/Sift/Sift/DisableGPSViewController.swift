//
//  DisableGPSViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 3/17/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class DisableGPSViewController: UIViewController {

    @IBOutlet weak var btnWakeUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default

        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: "wakeUp:")
        btnWakeUp.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    func wakeUp(sender:UITapGestureRecognizer){
        if let navController = self.navigationController {
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.locationManager.startUpdatingLocation()
            appDelegate.locationManager.startMonitoringSignificantLocationChanges()
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            navigationController?.navigationBarHidden = false
            navController.popViewControllerAnimated(true)
        }
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
