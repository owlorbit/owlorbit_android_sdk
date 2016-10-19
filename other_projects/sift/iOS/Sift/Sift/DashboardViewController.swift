//
//  DashboardViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON
import CoreData
import Alamofire
import AlamofireImage.Swift

import QuartzCore
import DGElasticPullToRefresh


class DashboardViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MapRadialViewControllerDelegate
{


    var data:[RoomUsersModel] = [];
    var boldRoomId = ""
    
    var rooms:NSMutableArray = NSMutableArray();
    var users:NSMutableArray = NSMutableArray();
    
    
    @IBOutlet weak var tableView: UITableView!

    //var userArrayList:NSMutableArray = [];
    //var rooms = Dictionary<String, NSMutableArray>();
    let downloader = ImageDownloader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"

        var createNewBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createNewBtnClick:")
        ApplicationManager.isLoggedIn = true;
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if(appDelegate.pendingNotification != nil){
            NotificationHelper.createPopupMessage(appDelegate, userInfo: appDelegate.pendingNotification!, applicationState: .Background)
        }
        //createNewBtn.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)

        self.navigationItem.rightBarButtonItem = createNewBtn
        self.tableView.registerNib(UINib(nibName: "ReadMessageTableViewCell", bundle:nil), forCellReuseIdentifier: "ReadMessageTableViewCell")

        tableView.separatorColor = ProjectConstants.AppColors.PRIMARY
        self.navigationController!.navigationBar.tintColor = ProjectConstants.AppColors.PRIMARY

        navigationController?.navigationBar.translucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = ProjectConstants.AppColors.PRIMARY
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        //getRoomsFromManagedObjects();
        
        initPushNotifications();
        initRooms();
        initProfile();

        /*if(!hasProfileImage()){
            loadProfileImage()
        }*/

        initDownloadProfile()
        initTableViewSettings()
    }
    
    func initPushNotifications(){
        OneSignal.IdsAvailable({ (userId, pushToken) in
            
            var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
            ApplicationManager.oneSignalDeviceId = userId
            UserApiHelper.enablePushNotification(userId, resultJSON: {
                (JSON) in
                
                }, error:{
                    (errStr) in
                    FullScreenLoaderHelper.removeLoader();
                    AlertHelper.createPopupMessage("Try again later...", title: "Push Notification Error")
            })
        });
        
    }
    
    func initTableViewSettings(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            //okay...
            //self?.getRoomsFromManagedObjects()
            self?.initRooms();
            
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(ProjectConstants.AppColors.PRIMARY)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    deinit {
        if(tableView != nil){
            tableView.dg_removePullToRefresh()
        }
    }

    func initDownloadProfile(){
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        UserApiHelper.loginUser(user.email, password: user.password, resultJSON: {
            (JSON) in

            FullScreenLoaderHelper.removeLoader();
            var hasFailed:Bool = (JSON["hasFailed"]) ? true : false
            if(!hasFailed){

                PersonalUserModel.updateUserFromLogin(user.email, password: user.password, serverReturnedData: JSON)

                if(!self.hasProfileImage()){
                    self.loadProfileImage()
                }else{
                    self.initProfile()
                }
            }
            }, error:{
               (errorMsg) in
                FullScreenLoaderHelper.removeLoader();
                AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
        });
        
    }
    
    func loadProfileImage(){
        let vc = ProfileImageUploadViewController(nibName: "ProfileImageUploadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true )
    }
    
    func initProfile(){
    
        dispatch_async(dispatch_get_main_queue()) {
            self.initProfileImage()
            var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
            var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + user.avatarOriginal
            var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)

            ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
                if let image = response.result.value {
                    ApplicationManager.userData.profileImage = image
                    FileHelper.saveImage(image, fileName:  (user.userId + ".png") )
                    FileHelper.saveRoundImage(image, fileName:  (user.userId + "-round.png") )
                    print("image save...")
                }
            }
        }
    }
    
    func initProfileImage(){

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        FileHelper.getUserImage(user.userId, completion: {
            data,error in

            if let imgData:NSData = data {
                ApplicationManager.userData.profileImage = UIImage(data:imgData,scale:1.0)
            }

            if let err:NSError = error {
               print("user image failed to load: \(err)")
            }
        })
        
        FileHelper.getRoundUserImage(user.userId, completion: {
            data,error in
            
            if let imgData:NSData = data {
                ApplicationManager.userData.profileRoundImage = UIImage(data:imgData,scale:1.0)
            }
            
            if let err:NSError = error {
                print("user image failed to load: \(err)")
            }
        })
        
        
    }

    func hasProfileImage()->Bool{
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;

        if(user.avatarOriginal.isEmpty || user.avatarOriginal == ""){
            return false;
        }else{
            return true;
        }
    }

    func getRoomsFromManagedObjects(){
        //self.data = RoomManagedModel.getAll()

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var getUsersAndGroup = RoomManagedModel.getUsersAndGroup(user.userId);
        

        //self.data = getUsersInRoomGrouped(getUsersAndGroup)
        self.tableView.reloadData()
    }

    
    func getUsersInRoomGrouped(usersAndGroup:[RoomManagedModel])->[RoomUsersModel]{
        
        var groupedUsers:[RoomUsersModel] = []

        for roomModel: RoomManagedModel in usersAndGroup {
            
            let roomId:String = roomModel.roomId;
            var isAdded:Bool = false

            for roomUser: RoomUsersModel in groupedUsers {
                if(roomUser.roomId == roomId){
                    isAdded = true
                    roomUser.roomManagedModels.append(roomModel)
                }
            }
            
            if(!isAdded){
                var roomUsersModel = RoomUsersModel()
                roomUsersModel.roomId = roomId
                roomUsersModel.roomManagedModels.append(roomModel)
                groupedUsers.append(roomUsersModel)
            }
        }

        return groupedUsers
    }
    
    func initRooms(){

        RoomApiHelper.getAllUsersInRoom({
            (JSON) in
                self.tableView.dg_stopLoading()
                self.users.removeAllObjects()
                self.rooms.removeAllObjects()
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["rooms"] {
                    var room:DashboardRoomModel = DashboardRoomModel(json:subJson)
                    //add to room list...
                    self.rooms.addObject(room)
                }
            
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["users"] {
                    var user:DashboardUserModel = DashboardUserModel(json:subJson)
                    //add to user list...
                    self.users.addObject(user)
                }

            
                self.tableView.reloadData()
            
            },error: {
            (message, errorCode) in
                
            }
        )
    }
    
    public func makeTextBold(targetRoomId:String, displayName:String, message:String){

        self.boldRoomId = targetRoomId
        var roomManagedModel:RoomManagedModel = RoomManagedModel.getById(targetRoomId)!

        roomManagedModel.lastMessage = message
        roomManagedModel.lastDisplayName = displayName

        RoomManagedModel.save()
        self.tableView.reloadData()
    }
    
    func createNewBtnClick(sender: AnyObject){
       let vc = WriteMessageViewController(nibName: "WriteMessageViewController", bundle: nil)

        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if(!self.hasProfileImage()){
            self.loadProfileImage()
        }
        
        //getRoomsFromManagedObjects();
    }
    
    @IBAction func btnTest(sender: AnyObject) {
        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true )
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "0 messages")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Start a message and start sharing your location!")
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool{
        return true
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool{
        return true
    }
    
    func didExitRoom(controller: MapRadialViewController){
        initRooms()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReadMessageTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:ReadMessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ReadMessageTableViewCell")! as! ReadMessageTableViewCell

        var roomData:DashboardRoomModel = rooms[indexPath.row] as! DashboardRoomModel
        cell?.populateRoomData(roomData, users:users)
  
        return cell!
    }
    
    func getDashboardUsersInRoom(roomId:String) -> DashboardUserModel?{
        var listOfUsers:NSMutableArray = NSMutableArray()
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        
        for usr in users as! [DashboardUserModel] {
            if(usr.roomId == roomId && usr.userId == user.userId){
                return usr
            }
        }
        
        return nil
    }

    func getRoomName(room:DashboardRoomModel)->String{
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var allUsers:String = "";
        var usersInRoom:NSMutableArray = getAllUsersInRoom(room.roomId, users: users)
        
        if(usersInRoom.count > 0) {
            for usr in usersInRoom as! [DashboardUserModel] {
                if(usr.userId != user.userId){
                    allUsers += usr.firstName + ", ";
                }
            }
        }
        
        if(room.roomName == ""){
            
            allUsers = allUsers.trim();
            if(allUsers.characters.last! == ","){
                allUsers = allUsers.substringToIndex(allUsers.endIndex.predecessor())
            }
            
            return allUsers
        }else{
            return room.roomName
        }
    }
    
    func getAllUsersInRoom(roomId:String, users:NSMutableArray) -> NSMutableArray{
        var listOfUsers:NSMutableArray = NSMutableArray()
        
        for usr in users as! [DashboardUserModel] {
            if(usr.roomId == roomId){
                listOfUsers.addObject(usr)
            }
        }
        
        return listOfUsers
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //get all user ids..?

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        //var roomData:RoomUsersModel = data[indexPath.row]
        var roomData:DashboardRoomModel = rooms[indexPath.row] as! DashboardRoomModel
        
        var userInRoom:DashboardUserModel = getDashboardUsersInRoom(roomData.roomId)! as DashboardUserModel
        var roomName:String = getRoomName(roomData)
        
        if(userInRoom.accepted){
            let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
            
            vc.chatRoomTitle = roomName
            vc.roomId = roomData.roomId
            vc.delegate = self;
            vc.hidesBottomBarWhenPushed = true            
            self.boldRoomId = "";
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            navigationController?.pushViewController(vc, animated: true )
            return
        }else{
            var refreshAlert = UIAlertController(title: "Accept Chat", message: "Do you want to join the room?", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                RoomApiHelper.acceptRoom(roomData.roomId, resultJSON:{
                    (JSON) in

                        if(roomData.userId != user.userId){
                            let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)
                            
                            vc.chatRoomTitle = roomName
                            vc.roomId = roomData.roomId
                            vc.delegate = self;
                            vc.hidesBottomBarWhenPushed = true
                            self.boldRoomId = "";
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                            self.navigationController?.pushViewController(vc, animated: true )
                            return
                        }
                    }, error:{
                        (Error) in
                        AlertHelper.createPopupMessage("\(Error)", title: "")
                })

            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
                RoomApiHelper.leaveRoom(roomData.roomId, resultJSON:{
                    (JSON) in
                    
                    self.initRooms()
                    
                    }, error:{
                        (Error) in
                        AlertHelper.createPopupMessage("\(Error)", title: "")
                })
                
                refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
 
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
