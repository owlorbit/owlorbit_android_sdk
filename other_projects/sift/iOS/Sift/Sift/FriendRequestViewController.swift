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
import DGElasticPullToRefresh


class FriendRequestViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate{

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];

    var initialUserArrayList:NSMutableArray = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSearchContainer.layer.cornerRadius = 4
        self.viewSearchContainer.layer.masksToBounds = true
        self.title = "Discover"
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = ProjectConstants.AppColors.PRIMARY
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.txtSearch.borderStyle = UITextBorderStyle.None
        self.txtSearch.attributedPlaceholder = NSAttributedString(string:self.txtSearch.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.txtSearch.tintColor = UIColor.whiteColor()
        self.txtSearch.delegate = self;
        // Do any additional setup after loading the view.

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)

        self.tableView.registerNib(UINib(nibName: "UserDiscoverTableViewCell", bundle:nil), forCellReuseIdentifier: "UserDiscoverTableViewCell")
        self.tableView.registerNib(UINib(nibName: "UserSearchPendingHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "UserSearchPendingHeaderView")
     
        navigationController?.hidesBarsOnTap = true
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
        tableView.es_addPullToRefresh(handler:{
            [weak self] in
            // refresh code
            self?.txtSearch.text = ""
            //self?.loadLists()
        })*/
        
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
        //self.tableView.es_stopPullToRefresh(completion: true)
        self.tableView.reloadData()
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

    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var view:UserSearchPendingHeaderView? = tableView.dequeueReusableHeaderFooterViewWithIdentifier("UserSearchPendingHeaderView")! as! UserSearchPendingHeaderView
        view!.txtHeaderLabel.text = self.sections[section] as! String;

        return view;
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    */
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
        
        return userArrayList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserSearchTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserDiscoverTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserDiscoverTableViewCell")! as! UserDiscoverTableViewCell

        var genericUser:GenericUserModel;

        genericUser = self.userArrayList[indexPath.row] as! GenericUserModel
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
        var genericUser:GenericUserModel = self.userArrayList[indexPath.row] as! GenericUserModel
        
        
        
        var alertController = UIAlertController(title: "Friend Request", message: "Send Request to \(genericUser.firstName)", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Accept")
            var genericUser:GenericUserModel;
            genericUser = self.userArrayList[indexPath.row] as! GenericUserModel
            UserApiHelper.addFriend(genericUser.userId, resultJSON:{
                (JSON) in
                
                AlertHelper.createPopupMessage("Please wait for the other user to accept!", title: "Friend Request Sent")
                //print("----- \(JSON)")
                self.loadLists()
            });
            
            //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.tableView.reloadData()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Decline")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)

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
