//
//  EnableLocationViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/30/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class EnableLocationViewController: UIViewController {

    @IBOutlet weak var btnSettingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "launchSettings:")
        btnSettingsView.addGestureRecognizer(gesture)
        
        //let gesture = UITapGestureRecognizer(target: self, action: "someAction:")
        //self.myView.addGestureRecognizer(gesture)
    }

    func launchSettings(sender:UITapGestureRecognizer){
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
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
