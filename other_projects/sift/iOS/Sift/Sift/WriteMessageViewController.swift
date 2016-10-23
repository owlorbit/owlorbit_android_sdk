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

class WriteMessageViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate{

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];
    var initialUserArrayList:NSMutableArray = [];
    var LOCK_PUSH:Bool = false
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    func initGroupButton(){
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "group_chat"), forState: .Normal)
        btnName.setImage(UIImage(named: "group_selected_chat"), forState: .Selected)
        btnName.setImage(UIImage(named: "group_selected_chat"), forState: .Focused)
        btnName.setImage(UIImage(named: "group_selected_chat"), forState: .Highlighted)
        btnName.frame = CGRectMake(0, 0, 30, 26)
        btnName.addTarget(self, action: Selector("btnGroupClick"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
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
        
        /*
        let vc = AddGroupViewController(nibName: "AddGroupViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true )*/
        
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
            let vc = GroupSettingsStep1ViewController(nibName: "GroupSettingsStep1ViewController", bundle: nil)
            vc.selectedUserArrayList = selectedUserArrayList
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true )
        }
    }

    
    
    func initTableViewSettings(){
        
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
        UserApiHelper.acceptedFriends({
            (JSON) in

            //self.userArrayList = self.defaultFriendList();
            
            
            for user: GenericUserManagedModel in (self.userArrayList as NSArray as! [GenericUserManagedModel] ) {
                var friendFound:Bool = false
                
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
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
        

        var userIds:NSMutableArray = NSMutableArray()
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        userIds.addObject(genericUser.userId)
        userIds.addObject(user.userId)
        
        print("dis: \(genericUser.userId)");
        FullScreenLoaderHelper.startLoader()

        ChatApiHelper.initChatMessage("Init Message", userIds: userIds, resultJSON:{
            
            (JSON) in
            
            print("zzzwgg: \(JSON)");
            
            let roomId:Int! = JSON["room_id"].int
            //var roomData:RoomManagedModel? = RoomManagedModel.getById(String(roomId))
            print("duhhh: \(String(roomId))");
            if let roomData = RoomManagedModel.getById(String(roomId)) as RoomManagedModel? {

                FullScreenLoaderHelper.removeLoader();
                if(!self.LOCK_PUSH){
                    print("VAMOS")
                    self.LOCK_PUSH = true;
                    let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                    vc.chatRoomTitle = roomData.attributes.name
                    vc.roomId = roomData.roomId
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true )
                }
                
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

            }else{

                print("waahhv")
                //var roomData:RoomManagedModel? = RoomManagedModel.getById(String(roomId))
                //print("zeerdP: \(roomData?.roomId)")
                RoomApiHelper.getRoomManaged(roomId!, resultJSON:{
                    (JSON3) in
                    
                    
                    print("fawef: \(JSON3)");
                    for (key,subJson):(String, SwiftyJSON.JSON) in JSON3["rooms"] {
                        var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                        
                        print("ferrrp: \(subJson)");
                        RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                            (JSON2) in
                            
                            
                            print("zzzzzzn: \(JSON2)")
                            
                            RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                                (roomAttribute) in
                                
                                roomModel.attributes = roomAttribute
                                if(roomModel.attributes.users.count > 0){
                                    roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                                }
                                
                                ApplicationManager.shareCoreDataInstance.saveContext()
                                var roomData:RoomManagedModel?  = RoomManagedModel.getById(roomModel.roomId)
                                
                                if(!self.LOCK_PUSH){
                                    FullScreenLoaderHelper.removeLoader();
                                    self.LOCK_PUSH = true;
                                    let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                                    vc.chatRoomTitle = roomModel.attributes.name
                                    vc.roomId = roomModel.roomId
                                    vc.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(vc, animated: true )
                                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                }
                                
                            })
                        });
                    }
                    
                    
                    
                });
            }

        },
            
            
            error:{
                (message, errorCode) in
                
                print("errorrr: \(message)")
        });
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
