//
//  WriteMessageViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/23/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON

class FriendRequestViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];

    var initialUserArrayList:NSMutableArray = [];
    var sections:NSMutableArray = ["Accept Friend?", "Requests (By You)", "Search Results"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSearchContainer.layer.cornerRadius = 4
        self.viewSearchContainer.layer.masksToBounds = true

        self.txtSearch.borderStyle = UITextBorderStyle.None
        self.txtSearch.attributedPlaceholder = NSAttributedString(string:self.txtSearch.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.txtSearch.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)

        self.tableView.registerNib(UINib(nibName: "UserSearchTableViewCell", bundle:nil), forCellReuseIdentifier: "UserSearchTableViewCell")

        self.tableView.registerNib(UINib(nibName: "UserSearchPendingHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "UserSearchPendingHeaderView")

        loadLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLists(){
        //friendsRequestedByYou
        
        userArrayList = []
        UserApiHelper.friendsRequestedByYou({
            (JSON) in

            self.pendingFriendArrayListYouSent = self.defaultFriendRequestedByYouList();
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                var genericUser:GenericUserModel = GenericUserModel(json: subJson);
                self.pendingFriendArrayListYouSent.addObject(genericUser)
            }
            self.tableView.reloadData()
        });
        
        UserApiHelper.friendsRequestedByThem({
            (JSON) in

            self.pendingFriendArrayListOthersSent = self.defaultFriendRequestedByThemList();
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                var genericUser:GenericUserModel = GenericUserModel(json: subJson);
                self.pendingFriendArrayListOthersSent.addObject(genericUser)
            }
            self.tableView.reloadData()
        });
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.txtSearch.text = ""
    }
    
    @IBAction func txtSearchOnChange(sender: AnyObject) {
        //print(self.txtSearch.text);
        
        if(self.txtSearch.text == ""){
            self.userArrayList = self.defaultFriendList();
            self.tableView.reloadData()
            return
        }
        
        UserApiHelper.findNonFriends(self.txtSearch.text!, resultJSON:{
            (JSON) in
            //self.userArrayList = self.defaultFriendList();
            self.userArrayList = []
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                var genericUser:GenericUserModel = GenericUserModel(json: subJson);
                self.userArrayList.addObject(genericUser)
            }
            self.tableView.reloadData()
        });
    }
    
    func defaultFriendRequestedByThemList()->NSMutableArray{
        return [];
    }
    
    func defaultFriendRequestedByYouList()->NSMutableArray{
        return [];
    }
    
    func defaultFriendList() ->NSMutableArray{
        return self.initialUserArrayList;
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var view:UserSearchPendingHeaderView? = tableView.dequeueReusableHeaderFooterViewWithIdentifier("UserSearchPendingHeaderView")! as! UserSearchPendingHeaderView
        view!.txtHeaderLabel.text = self.sections[section] as! String;

        return view;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No One Found")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Search for Contacts!")
    }

    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool{
        return true
    }

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return self.pendingFriendArrayListOthersSent.count
        }else if(section == 1){
            return self.pendingFriendArrayListYouSent.count;
        }else{
            return userArrayList.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserSearchTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserSearchTableViewCell")! as! UserSearchTableViewCell

        var genericUser:GenericUserModel;
        if(indexPath.section == 0){
            genericUser = self.pendingFriendArrayListOthersSent[indexPath.row] as! GenericUserModel            
        }else if(indexPath.section == 1){
            genericUser = self.pendingFriendArrayListYouSent[indexPath.row] as! GenericUserModel
        }else{
            genericUser = self.userArrayList[indexPath.row] as! GenericUserModel
        }

        cell?.populate(genericUser)
        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return self.sections.count
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendantOfView(self.tableView) {
            return false
        }
        return true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        //if not a friend, send a friend request if friend request not sent....
        //if a friend, start a message.
        //var genericUser:GenericUserModel = self.userArrayList[indexPath.row] as! GenericUserModel
        var genericUser:GenericUserModel;
        
        if(indexPath.section == 0){
            genericUser = self.pendingFriendArrayListOthersSent[indexPath.row] as! GenericUserModel
            print("ask if they accept or decline")
            
            let name:String = genericUser.firstName + " " + genericUser.lastName
            // Create the alert controller
            var alertController = UIAlertController(title: "Friendship Request", message: "Accept friendship from \(name)", preferredStyle: .Alert)
            
            // Create the actions
            var okAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("Accept")
                UserApiHelper.acceptFriendRequest(genericUser.userId, resultJSON:{
                    (JSON) in
                    print(JSON)
                    self.loadLists()
                });
                
            }

            var cancelAction = UIAlertAction(title: "Decline", style: UIAlertActionStyle.Destructive) {
                UIAlertAction in
                NSLog("Decline")
                UserApiHelper.declineFriendRequest(genericUser.userId, resultJSON:{
                    (JSON) in
                    print(JSON)
                    self.loadLists()
                });
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if(indexPath.section == 1){
            print("dont do anything...")
            AlertHelper.createPopupMessage("Still waiting for a response.", title: "Friend Request")
        }else{
            genericUser = self.userArrayList[indexPath.row] as! GenericUserModel
            UserApiHelper.addFriend(genericUser.userId, resultJSON:{
                (JSON) in
                
                AlertHelper.createPopupMessage("Please wait for the other user to accept!", title: "Friend Request Sent")
                //print("----- \(JSON)")
                self.loadLists()
            });
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.reloadData()
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
