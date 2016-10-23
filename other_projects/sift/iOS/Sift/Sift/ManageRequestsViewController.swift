//
//  ManageRequestsViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/11/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON
import DGElasticPullToRefresh

class ManageRequestsViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate{

        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var scType: UISegmentedControl!
        
        var userArrayList:NSMutableArray = [];
        var pendingFriendArrayListOthersSent:NSMutableArray = [];
        var pendingFriendArrayListYouSent:NSMutableArray = [];
        
        var initialUserArrayList:NSMutableArray = [];
        var sections:NSMutableArray = ["Received", "Sent"];
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Requests"
            navigationController?.navigationBar.translucent = false
            navigationController?.navigationBar.barTintColor = ProjectConstants.AppColors.PRIMARY
            navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationController?.navigationBar.shadowImage = UIImage()
            
            self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

            // Do any additional setup after loading the view.
            
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            
            tap.cancelsTouchesInView = false;
            view.addGestureRecognizer(tap)
            
            self.tableView.registerNib(UINib(nibName: "UserDiscoverTableViewCell", bundle:nil), forCellReuseIdentifier: "UserDiscoverTableViewCell")
            self.tableView.registerNib(UINib(nibName: "UserSearchPendingHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "UserSearchPendingHeaderView")
            
            loadLists()
            
            nofucksrightnow()
            initTableViewSettings()
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
            textField.resignFirstResponder()
            return true
        }
        
        func initTableViewSettings(){
            
            /*
            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
            
            loadingView.tintColor = UIColor.whiteColor()
            tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
                // Add your logic here
                // Do not forget to call dg_stopLoading() at the end
                //okay...
                
                self?.loadLists()
                }, loadingView: loadingView)
            tableView.dg_setPullToRefreshFillColor(ProjectConstants.AppColors.PRIMARY)
            tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
            */
            
            tableView.es_addPullToRefresh(handler:{
                [weak self] in
                
                self?.loadLists()
            })
        }
        
        deinit {
            if(tableView != nil){
                tableView.dg_removePullToRefresh()
            }
        }
        
        
        
        func nofucksrightnow(){
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        }
        
        func keyboardWillShow(notification: NSNotification) {
            let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]!.intValue
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
            let keyboardFrameConvertedToViewFrame = view.convertRect(keyboardFrame!, fromView: nil)
            let curveAnimationOption = UIViewAnimationOptions(rawValue: UInt(animationCurve))
            let options: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, curveAnimationOption]
            UIView.animateWithDuration(animationDuration, delay: 0, options:options, animations: { () -> Void in
                let insetHeight = (self.tableView.frame.height + self.tableView.frame.origin.y) - keyboardFrameConvertedToViewFrame.origin.y
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
                self.tableView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, insetHeight, 0)
                }) { (complete) -> Void in
            }
        }
        
        @IBAction func scOnChange(sender: AnyObject) {
            print("segment control change... \(scType.selectedSegmentIndex)")
            self.tableView.reloadData()
        }

        func keyboardWillHide(notification: NSNotification) {
            let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]!.intValue
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
            let keyboardFrameConvertedToViewFrame = view.convertRect(keyboardFrame!, fromView: nil)
            let curveAnimationOption = UIViewAnimationOptions(rawValue: UInt(animationCurve))
            let options: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, curveAnimationOption]
            UIView.animateWithDuration(animationDuration, delay: 0, options:options, animations: { () -> Void in
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                self.tableView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
                }) { (complete) -> Void in
            }
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
                
                self.tableView.es_stopPullToRefresh(completion: true)
            });
            
        }
        
        func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
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

        func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
            return NSAttributedString(string: "No Requests")
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
            
            if(scType.selectedSegmentIndex == 0){
                return self.pendingFriendArrayListOthersSent.count
            }else {
                return self.pendingFriendArrayListYouSent.count;
            }
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UserSearchTableViewCell.cellHeight();
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell:UserDiscoverTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserDiscoverTableViewCell")! as! UserDiscoverTableViewCell
            
            var genericUser:GenericUserModel;
            if(scType.selectedSegmentIndex == 0){
                genericUser = self.pendingFriendArrayListOthersSent[indexPath.row] as! GenericUserModel
            }else {
                genericUser = self.pendingFriendArrayListYouSent[indexPath.row] as! GenericUserModel
            }
            
            cell?.populate(genericUser)
            return cell!
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
            
            if(scType.selectedSegmentIndex == 0){
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
