//
//  GroupSettingsStep1ViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/8/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON

class GroupSettingsStep1ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedUserArrayList:NSMutableArray = [];
    
    var roomId:String = ""
    var LOCK_PUSH:Bool = false
    var CELLS = ["NAME", "IS_PUBLIC", "FRIENDS_ONLY"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Group Chat"
        // Do any additional setup after loading the view.
        LOCK_PUSH = false
        
        self.tableView.registerNib(UINib(nibName: "GroupNameTableViewCell", bundle:nil), forCellReuseIdentifier: "GroupNameTableViewCell")
        self.tableView.registerNib(UINib(nibName: "GroupIsPublicTableViewCell", bundle:nil), forCellReuseIdentifier: "GroupIsPublicTableViewCell")
        self.tableView.registerNib(UINib(nibName: "GroupIsFriendsOnlyTableViewCell", bundle:nil), forCellReuseIdentifier: "GroupIsFriendsOnlyTableViewCell")
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
        var rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "btnSubmit:")
        self.navigationItem.rightBarButtonItem = rightBtn
    }

    func btnSubmit(sender: AnyObject){
        
        if(CreateGroupManager.roomName == ""){
            AlertHelper.createPopupMessage("Please Name Your Room", title: "")
            return;
        }
        print("use the power of the singleton.. \(CreateGroupManager.roomName)")
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        selectedUserArrayList.addObject(user.userId)
        
        
        FullScreenLoaderHelper.startLoader()
        
        ChatApiHelper.initChatMessage("Init Message", userIds: self.selectedUserArrayList, resultJSON:  {
            (JSON) in
            

                let roomId:Int! = JSON["room_id"].int
                //var roomData:RoomManagedModel? = RoomManagedModel.getById(String(roomId))
                
                if let roomData = RoomManagedModel.getById(String(roomId)) as RoomManagedModel? {
                    
                    
                    FullScreenLoaderHelper.removeLoader();
                    if(!self.LOCK_PUSH){
                        self.LOCK_PUSH = true;
                        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                        vc.chatRoomTitle = roomData.attributes.name
                        vc.roomId = roomData.roomId
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true )
                    }
                    
                }else{

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
                                        FullScreenLoaderHelper.removeLoader();
                                        self.LOCK_PUSH = true;
                                        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                                        vc.chatRoomTitle = roomData!.attributes.name
                                        vc.roomId = roomData!.roomId
                                        vc.hidesBottomBarWhenPushed = true
                                        self.navigationController?.pushViewController(vc, animated: true )
                                    }
                                    
                                })
                                
                                
                            });
                        }
                    });
                }
                
            
            
            
            }, error:{
                (message, errorCode) in
                
                if(errorCode < 0){
                    UserApiHelper.updateToken({
                        //things are updated... so now call the send message again..
                            self.btnSubmit("")
                        }, error: {
                            (errorMsg) in
                            AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                    })
                }
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        resignFirstResponder()
        
        //[[self.tableView superView] endEditing:YES];
        self.tableView.superview?.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CELLS.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cellType:String = self.CELLS[indexPath.row] as! String
        
        switch(cellType){
            case "NAME":
                var cell:GroupNameTableViewCell? = tableView.dequeueReusableCellWithIdentifier("GroupNameTableViewCell")! as! GroupNameTableViewCell
                return cell!
                print("print one")
                break;
            case "IS_PUBLIC":
                var cell:GroupIsPublicTableViewCell? = tableView.dequeueReusableCellWithIdentifier("GroupIsPublicTableViewCell")! as! GroupIsPublicTableViewCell
                return cell!
                break;
            case "FRIENDS_ONLY":
                var cell:GroupIsFriendsOnlyTableViewCell? = tableView.dequeueReusableCellWithIdentifier("GroupIsFriendsOnlyTableViewCell")! as! GroupIsFriendsOnlyTableViewCell
                return cell!
                break;
            default:
                var cell:GroupNameTableViewCell? = tableView.dequeueReusableCellWithIdentifier("GroupNameTableViewCell")! as! GroupNameTableViewCell
                return cell!
                break
        }
        
        return GroupNameTableViewCell()
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
