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

        //var publicKey = "dc3db1715337d4451943f43cf9bf073164a17609c97006ec04970117037f121d"
        //var privateKey = "b2c3db857382d728387c505b97616584b29ecf85f911fd4408e55c94aca9169f"
        EncryptUtil.test()        

        /*
        UserApiHelper.test({
        (JSON) in
        print("111 Done!")
        });*/
        
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
            
            PersonalUserModel.updateUserFromLogin(username, password: password, serverReturnedData: JSON)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setupLoggedInViewController()
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
