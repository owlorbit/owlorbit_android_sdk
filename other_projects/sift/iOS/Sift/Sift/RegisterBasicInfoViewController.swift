//
//  RegisterBasicInfoViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/13/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class RegisterBasicInfoViewController: UIViewController, RegistrationBasicInfoDelegate, RegistrationBasicInfoWitheBetaValueDelegate {

    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var data:NSMutableArray = [];
    
    var firstName:String = "";
    var lastName:String = "";
    var registrationUser:RegistrationUser = RegistrationUser();
    var enableOnlyBetaInvite:Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)

        self.tableView.registerNib(UINib(nibName: "RegistrationBasicInfoValueTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationBasicInfoValueTableViewCell")

        self.tableView.registerNib(UINib(nibName: "RegistrationBetaTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationBetaTableViewCell")

        self.tableView.backgroundColor = UIColor.clearColor();
        
        getInfo()
        // Do any additional setup after loading the view.
    }
    
    func getInfo(){
        
        FullScreenLoaderHelper.startLoader()
        
        
        var delayInSeconds:Float = 0.5;
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),  Int64(  0.5 * Double(NSEC_PER_SEC)  ))
        dispatch_after(time, dispatch_get_main_queue()) {

            InfoApiHelper.getServerInfo({
                (JSON) in

                FullScreenLoaderHelper.removeLoader()
                if(JSON["enable_only_beta_invite"].boolValue){
                    self.enableOnlyBetaInvite = true;
                }else{
                    self.enableOnlyBetaInvite = false;
                }
                self.data = [1];
                self.tableView.reloadData()
                
                }, error:{
                    (message) in
                    FullScreenLoaderHelper.removeLoader()
                    self.data = [1];
                    self.tableView.reloadData()
                }
            )}
    }
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(self.enableOnlyBetaInvite){
            return RegistrationBetaTableViewCell.cellHeight()
        }
        return RegistrationBasicInfoValueTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func submitRegistration(firstName:String, lastName:String, betaCode:String){
        
        registrationUser.firstName = firstName;
        registrationUser.lastName = lastName;
        registrationUser.betaCode = betaCode;

        UserApiHelper.createUser(registrationUser, resultJSON: {
            (JSON) in
            
            PersonalUserModel.insertFromRegistration(self.registrationUser, serverReturnedData: JSON)
            self.navigationController!.popToRootViewControllerAnimated(true)
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setupLoggedInViewController()
            }, error:{
                (Error) in
                AlertHelper.createPopupMessage("\(Error)", title: "")
            }
            
        );
    }
    

    func submitRegistration(firstName:String, lastName:String){

        registrationUser.firstName = firstName;
        registrationUser.lastName = lastName;
        UserApiHelper.createUser(registrationUser, resultJSON: {
            (JSON) in
            
            PersonalUserModel.insertFromRegistration(self.registrationUser, serverReturnedData: JSON)
            self.navigationController!.popToRootViewControllerAnimated(true)
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setupLoggedInViewController()
        }, error:{
                (Error) in
                AlertHelper.createPopupMessage("\(Error)", title: "")
            }
        
        );
    }
    //pangea money transfers
    //tanbas,
    //cec - will
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(self.enableOnlyBetaInvite){
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("RegistrationBetaTableViewCell") as! RegistrationBetaTableViewCell
            cell.delegate = self
            cell.populate()
            return cell
            
        }else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("RegistrationBasicInfoValueTableViewCell") as! RegistrationBasicInfoValueTableViewCell
            cell.delegate = self
            cell.populate()
            return cell
        }
    }
}
