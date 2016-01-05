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

class WriteMessageViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userArrayList:NSMutableArray = [];
    var pendingFriendArrayListOthersSent:NSMutableArray = [];
    var pendingFriendArrayListYouSent:NSMutableArray = [];
    var initialUserArrayList:NSMutableArray = [];
    //var sections:NSMutableArray = ["Friend or Foe?", "Requests (By You)", "Friends"];
    var LOCK_PUSH:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LOCK_PUSH = false
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

        UserApiHelper.acceptedFriends({
            (JSON) in

            self.userArrayList = self.defaultFriendList();
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                var genericUser:GenericUserModel = GenericUserModel(json: subJson);
                self.userArrayList.addObject(genericUser)
            }

            self.tableView.reloadData()
            
        });
        
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
        return UserSearchTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserSearchTableViewCell")! as! UserSearchTableViewCell

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
        //var genericUser:GenericUserModel = self.userArrayList[indexPath.row] as! GenericUserModel
        var genericUser:GenericUserModel;
        
        genericUser = self.userArrayList[indexPath.row] as! GenericUserModel

        var userIds:NSMutableArray = NSMutableArray()
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        userIds.addObject(genericUser.userId)
        userIds.addObject(user.userId)
        
        print("dis: \(genericUser.userId)");

        ChatApiHelper.initChatMessage("Init Message", userIds: userIds, resultJSON:{
            (JSON) in
            
            let roomId:Int? = JSON["room_id"].int
            //var roomData:RoomManagedModel? = RoomManagedModel.getById(String(roomId))

            if let roomData = RoomManagedModel.getById(String(roomId)) as RoomManagedModel? {
                
                
                if(!self.LOCK_PUSH){
                    self.LOCK_PUSH = true;
                    let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
                    vc.chatRoomTitle = roomData.attributes.name
                    vc.roomId = roomData.roomId
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true )
                }
                
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

            }else{
                
                print("SHIT BAG \(JSON["room_id"].string)")
                var roomData:RoomManagedModel? = RoomManagedModel.getById(String(roomId))
                RoomApiHelper.getRoomManaged(roomId!, resultJSON:{
                    (JSON3) in
                    
                    for (key,subJson):(String, SwiftyJSON.JSON) in JSON3["rooms"] {
                        var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                        RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                            (JSON2) in
                            
                            RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                                (roomAttribute) in
                                
                                roomModel.attributes = roomAttribute
                                if(roomModel.attributes.users.count > 0){
                                    roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                                }
                                
                                ApplicationManager.shareCoreDataInstance.saveContext()
                                roomData = RoomManagedModel.getById(roomModel.roomId)
                                
                                if(!self.LOCK_PUSH){
                                    self.LOCK_PUSH = true;
                                    let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
                                    vc.chatRoomTitle = roomData!.attributes.name
                                    vc.roomId = roomData!.roomId
                                    vc.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(vc, animated: true )
                                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                                }
                                
                            })
                            
                            
                        });
                    }
                });
                
                
                
                
            }

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
