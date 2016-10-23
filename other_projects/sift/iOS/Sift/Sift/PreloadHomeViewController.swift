//
//  PreloadHomeViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/10/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class PreloadHomeViewController: UIViewController {

    
    
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        // Do any additional setup after loading the view.

        btnSignUp.layer.cornerRadius = 4;
        btnSignUp.clipsToBounds = true;
        updateLogo()
    }
    
    func updateLogo(){
        //self.logoHeightConstraint.constant = 50
        
        /*
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignUpClick(sender: AnyObject) {
        var viewController : RegisterViewController = RegisterViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnLogInClick(sender: AnyObject) {
        var viewController : LoginViewController = LoginViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
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
