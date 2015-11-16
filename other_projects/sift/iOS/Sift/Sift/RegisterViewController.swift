//
//  RegisterViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/12/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class RegisterViewController: UIViewController, Registration1Delegate {

    @IBOutlet weak var btnBack: UIImageView!
    
    var data:NSMutableArray = [1];
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToHome")
        tap.numberOfTapsRequired = 1;
        btnBack.userInteractionEnabled = true;
        btnBack.addGestureRecognizer(tap)

        self.navigationController?.setNavigationBarHidden(true, animated: false);
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)

        self.tableView.registerNib(UINib(nibName: "Registration1ValueTableViewCell", bundle: nil), forCellReuseIdentifier: "Registration1ValueTableViewCell")
        self.tableView.backgroundColor = UIColor.clearColor();

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Registration1ValueTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    @IBAction func btnNextTouchUp(sender: AnyObject) {
        var viewController : RegisterBasicInfoViewController = RegisterBasicInfoViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    func backToHome(){
        self.navigationController?.popToRootViewControllerAnimated(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Registration1ValueTableViewCell") as! Registration1ValueTableViewCell
        cell.delegate = self
        return cell
    }
    
    func nextRegistration(){
        var viewController : RegisterBasicInfoViewController = RegisterBasicInfoViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
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
