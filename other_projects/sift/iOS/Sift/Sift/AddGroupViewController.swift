//
//  AddGroupViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/3/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON
import DGElasticPullToRefresh

class AddGroupViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];
    var initialUserArrayList:NSMutableArray = [];
    var LOCK_PUSH:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        LOCK_PUSH = false
        self.viewSearchContainer.layer.cornerRadius = 4
        self.viewSearchContainer.layer.masksToBounds = true
        
        self.txtSearch.borderStyle = UITextBorderStyle.None
        self.txtSearch.attributedPlaceholder = NSAttributedString(string:self.txtSearch.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.txtSearch.delegate = self;
        self.txtSearch.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)
        
        self.tableView.registerNib(UINib(nibName: "UserGroupSelectTableViewCell", bundle:nil), forCellReuseIdentifier: "UserGroupSelectTableViewCell")

        var rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "btnNextClick:")
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        loadLists()
        nofucksrightnow()
        
        initTableViewSettings()
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func btnNextClick(){
        /*let vc = AddGroupViewController(nibName: "AddGroupViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true )*/
        
        print("print next..")
        
    }
    
    func initTableViewSettings(){
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
        
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
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
        UserApiHelper.acceptedFriends({
            (JSON) in
            
            //self.userArrayList = self.defaultFriendList();
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                //var genericUser:GenericUserModel = GenericUserModel(json: subJson, isFriend:true);
                var genericUser:GenericUserManagedModel = GenericUserManagedModel.initWithJsonFriend(subJson);
                
                if(!self.isDuplicate(genericUser)){
                    self.userArrayList.addObject(genericUser)
                }
            }
            
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
            
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
        
        UserApiHelper.findFriends(self.txtSearch.text!, resultJSON:{
            (JSON) in
            //self.userArrayList = self.defaultFriendList();
            self.userArrayList = []
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
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
        return self.initialUserArrayList;
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
        var genericUser:GenericUserManagedModel;
        genericUser = self.userArrayList[indexPath.row] as! GenericUserManagedModel

        if(genericUser.checked){
            genericUser.checked = false;
        }else{
            genericUser.checked = true;
        }
        tableView.reloadData()
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
