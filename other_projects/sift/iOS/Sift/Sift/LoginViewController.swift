//
//  LoginViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import CoreData




class LoginViewController: UIViewController, LoginDelegate {

    @IBOutlet weak var lblHeghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    var data:NSMutableArray = [1];
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        self.tableView.registerNib(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        self.tableView.backgroundColor = UIColor.clearColor();
        //test()
        
        
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)
        
        
        print("balloon2")
        
        
        EncryptUtil.test()
        //print(EncryptUtil.sha256("erg".dataUsingEncoding(NSUTF8StringEncoding)!))
        
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true);        
    }
  
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LoginTableViewCell.cellHeight()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("LoginTableViewCell") as! LoginTableViewCell

        cell.delegate = self;
        cell.populate()
        return cell
    }

    func startRegistration(){
        var viewController : RegisterViewController = RegisterViewController();
        self.navigationController!.pushViewController(viewController, animated: true)        
    }

    func signIn(username: String, password: String){
        
        FullScreenLoaderHelper.startLoader()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))

        dispatch_after(delayTime, dispatch_get_main_queue()) {
            UserApiHelper.loginUser(username, password: password, resultJSON: {
                (JSON) in

                FullScreenLoaderHelper.removeLoader();
                var hasFailed:Bool = (JSON["hasFailed"]) ? true : false
                if(!hasFailed){
                    PersonalUserModel.updateUserFromLogin(username, password: password, serverReturnedData: JSON)

                    //TODO SWITCH THE COMMENTED OUT
                    //if !ApplicationManager.parseDeviceId.isEmpty {
                    if !ApplicationManager.parseDeviceId.isEmpty && !ApplicationManager.isTesting {
                        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
                        UserApiHelper.enablePushNotification(ApplicationManager.parseDeviceId, resultJSON: {
                            (JSON) in
                            
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.setupLoggedInViewController()
                            
                            }, error:{
                                (errStr) in
                                FullScreenLoaderHelper.removeLoader();
                                AlertHelper.createPopupMessage("Try again later...", title: "Login Error")
                                print("ze error \(errStr)")
                        });
                        
                        
                        
                        
                        
                    }else{
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.setupLoggedInViewController()
                    }
                }else{
                    if(JSON["message"].string != ""){
                        AlertHelper.createPopupMessage(JSON["message"].string!.removeHtml()!, title: "Login Error")
                    }else{
                        AlertHelper.createPopupMessage("Try again later...", title: "Login Error")
                    }
                }
                
                }, error:{
                    (errorMsg) in
                    FullScreenLoaderHelper.removeLoader();
                    AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
            });
        }
    }

    @IBAction func btnSignInTouchUp(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setupLoggedInViewController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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
