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

class AddUserToRoomViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate{

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];
    var initialUserArrayList:NSMutableArray = [];
    var LOCK_PUSH:Bool = false
    var roomId:String = ""
    var selectedUserArrayList:NSMutableArray = [];
    var homeBtn : UIBarButtonItem?
    var enableGroupSelected:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LOCK_PUSH = false
        self.viewSearchContainer.layer.cornerRadius = 4
        self.viewSearchContainer.layer.masksToBounds = true

        self.title = "Chat"
        self.txtSearch.borderStyle = UITextBorderStyle.None
        self.txtSearch.attributedPlaceholder = NSAttributedString(string:self.txtSearch.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.txtSearch.delegate = self;
        self.txtSearch.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        self.navigationController!.navigationBar.tintColor = ProjectConstants.AppColors.PRIMARY
        
        navigationController?.navigationBar.translucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = ProjectConstants.AppColors.PRIMARY
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)

        self.tableView.registerNib(UINib(nibName: "UserGroupSelectTableViewCell", bundle:nil), forCellReuseIdentifier: "UserGroupSelectTableViewCell")

        self.tableView.registerNib(UINib(nibName: "UserSearchPendingHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "UserSearchPendingHeaderView")

        initGroupButton()
        loadLists()
        nofucksrightnow()
        initTableViewSettings()
    }
    
    
    func initGroupButton(){
        
        enableGroupSelected = true;
        var rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "btnNextClick:")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.LOCK_PUSH = false;
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func btnGroupClick(){
        
        enableGroupSelected = true;
        var rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "btnNextClick:")
        self.navigationItem.rightBarButtonItem = rightBtn

        var cancelBtn : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "btnCancelClick:")
        
        homeBtn = self.navigationItem.leftBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        self.tableView.reloadData()
    }
    
    func btnCancelClick(sender: AnyObject){

        enableGroupSelected = false
        self.navigationItem.leftBarButtonItem = homeBtn
        initGroupButton()
        tableView.reloadData()
    }
    
    func btnNextClick(sender: AnyObject){
        
        
        if(selectedUserArrayList.count == 0){
            AlertHelper.createPopupMessage("Please select a user!", title: "Hold Up")
        }else{
            RoomApiHelper.addNewUsers(roomId, userIds: selectedUserArrayList, resultJSON: {
                (JSON) in
                        //send user back..
                    if let navController = self.navigationController {
                        navController.popViewControllerAnimated(true)
                    }
                }, error: {
                    (Error) in
                    AlertHelper.createPopupMessage("\(Error)", title: "")
                })
        }
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
            // refresh code
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

        self.userArrayList = NSMutableArray(array: GenericUserManagedModel.getByFriend())
        UserApiHelper.friendsNotInRoom(roomId, resultJSON: {
            (JSON) in

            //self.userArrayList = self.defaultFriendList();
            for user: GenericUserManagedModel in (self.userArrayList as NSArray as! [GenericUserManagedModel] ) {
                var friendFound:Bool = false
                
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["friends"] {
                    var genericUser:GenericUserManagedModel = GenericUserManagedModel.initWithJsonFriend(subJson);
                    
                    if(user.userId == genericUser.userId){
                        friendFound = true;
                    }
                }

                
                if(!friendFound){
                    do{
                        ApplicationManager.shareCoreDataInstance.managedObjectContext.deleteObject(user)
                        self.userArrayList.removeObject(user)
                        try ApplicationManager.shareCoreDataInstance.managedObjectContext.save()
                    }catch{
                        
                    }
                    //break;
                }
            }
      
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                var genericUser:GenericUserManagedModel = GenericUserManagedModel.initWithJsonFriend(subJson);
                
                if(!self.isDuplicate(genericUser)){
                    self.userArrayList.addObject(genericUser)
                }
            }

            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
            ApplicationManager.NOTIFICATION_LOCK_PUSH = false;
            
        });
    }
    
    
    func isDuplicate(genericUserModel:GenericUserManagedModel)->Bool{
        
        for user: GenericUserManagedModel in (userArrayList as NSArray as! [GenericUserManagedModel] ) {

            if genericUserModel.userId == user.userId {
                return true
            }
        }

        return false
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func txtSearchOnChange(sender: AnyObject) {
        //print(self.txtSearch.text);
        
        if(self.txtSearch.text == ""){
            self.userArrayList = self.defaultFriendList();
            self.tableView.reloadData()
            return
        }
        
        UserApiHelper.friendsNotInRoomWithSearch(roomId, term:self.txtSearch.text!, resultJSON:{
            (JSON) in
            //self.userArrayList = self.defaultFriendList();
            self.userArrayList = []
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["friends"] {
                //var genericUser:GenericUserModel = GenericUserModel(json: subJson);
                var genericUser:GenericUserManagedModel = GenericUserManagedModel.initWithJsonFriend(subJson);
                
                if(!self.isDuplicate(genericUser)){
                    self.userArrayList.addObject(genericUser)
                }
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
        return NSMutableArray(array: GenericUserManagedModel.getByFriend());
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "0 friends")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "This app is useless without contacts...")
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
        return UserGroupSelectTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserGroupSelectTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserGroupSelectTableViewCell")! as! UserGroupSelectTableViewCell

        var genericUser:GenericUserManagedModel;
        genericUser = self.userArrayList[indexPath.row] as! GenericUserManagedModel
        
        if(enableGroupSelected){
            if(isInCheckedList(genericUser.userId)){
                genericUser.checked = true;
            }else{
                genericUser.checked = false;
            }
            
            cell?.populate(genericUser)
        }else{
            cell?.populateNoMulti(genericUser)
        }
        return cell!
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendantOfView(self.tableView) {
            return false
        }
        return true
    }
    
    func addUserToCheckedList(userId:String){
        for userIdInArray in (selectedUserArrayList as NSArray as! [String]) {
            if(userIdInArray == userId){
                print("already added!")
                return;
            }
        }
        
        selectedUserArrayList.addObject(userId)
    }
    
    
    func removeUserFromCheckedList(userId:String){
        
        for (var i:Int=0; i < selectedUserArrayList.count; i++) {
            var userIdInArray:String = selectedUserArrayList.objectAtIndex(i) as! String
            if(userId == userIdInArray){
                selectedUserArrayList.removeObjectAtIndex(i)
                return;
            }
        }
    }
    
    func isInCheckedList(userId:String)->Bool{
        for (var i:Int=0; i < selectedUserArrayList.count; i++) {
            var userIdInArray:String = selectedUserArrayList.objectAtIndex(i) as! String
            if(userId == userIdInArray){
                return true;
            }
        }
        
        return false;
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            var genericUser:GenericUserManagedModel;
            genericUser = self.userArrayList[indexPath.row] as! GenericUserManagedModel

            UserApiHelper.removeFriend(genericUser.userId, resultJSON: {
                    (JSON) in
                        self.loadLists()
                        RoomManagedModel.removeAll()
                }, error: {
                    (Error) in
                        AlertHelper.createPopupMessage("\(Error)", title: "")
            })
            //AlertHelper.createPopupMessage("removing " + genericUser.userId, title: "title")
            //numbers.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        //if not a friend, send a friend request if friend request not sent....
        //if a friend, start a message.
        //var genericUser:GenericUserModel = self.userArrayList[indexPath.row] as! GenericUserModel
        var genericUser:GenericUserManagedModel;
        genericUser = self.userArrayList[indexPath.row] as! GenericUserManagedModel
        
        if(enableGroupSelected){
            
            
            if(genericUser.checked){
                genericUser.checked = false;
                removeUserFromCheckedList(genericUser.userId)
            }else{
                genericUser.checked = true;
                addUserToCheckedList(genericUser.userId)
            }
            self.tableView.reloadData()
            return;
        }        
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
