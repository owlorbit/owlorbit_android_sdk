//
//  RegisterBasicInfoViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/13/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class RegisterBasicInfoViewController: UIViewController, RegistrationBasicInfoDelegate {

    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var data:NSMutableArray = [1];
    
    var firstName:String = "";
    var lastName:String = "";
    var registrationUser:RegistrationUser=RegistrationUser();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToHome")
        tap.numberOfTapsRequired = 1;
        btnBack.userInteractionEnabled = true;
        btnBack.addGestureRecognizer(tap)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)

        self.tableView.registerNib(UINib(nibName: "RegistrationBasicInfoValueTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationBasicInfoValueTableViewCell")
        self.tableView.backgroundColor = UIColor.clearColor();
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RegistrationBasicInfoValueTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func submitRegistration(firstName:String, lastName:String){

        registrationUser.firstName = firstName;
        registrationUser.lastName = lastName;
        
        UserApiHelper.createUser(registrationUser, resultJSON: {
            (JSON) in
            
            UserModel.insertFromRegistration(self.registrationUser)
            print("Done!")
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RegistrationBasicInfoValueTableViewCell") as! RegistrationBasicInfoValueTableViewCell
        cell.delegate = self
        cell.populate()
        return cell
    }

}
