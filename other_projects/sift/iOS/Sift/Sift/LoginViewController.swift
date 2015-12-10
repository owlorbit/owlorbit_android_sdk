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
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        self.tableView.registerNib(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        self.tableView.backgroundColor = UIColor.clearColor();
        test()
    }

    func test(){

        self.logoHeightConstraint.constant = 0
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        
        print(ApplicationManager.deviceId)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

        UserApiHelper.loginUser(username, password: password, resultJSON: {
            (JSON) in

            var hasFailed:Bool = (JSON["hasFailed"]) ? true : false
            if(!hasFailed){
                PersonalUserModel.updateUserFromLogin(username, password: password, serverReturnedData: JSON)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.setupLoggedInViewController()
            }else{
                if(JSON["message"].string != ""){
                    AlertHelper.createPopupMessage(JSON["message"].string!.removeHtml()!, title: "Login Error")
                }else{
                    AlertHelper.createPopupMessage("Try again later...", title: "Login Error")
                }
            }

        });
        
    }

    @IBAction func btnSignInTouchUp(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setupLoggedInViewController()
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
