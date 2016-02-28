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


    var data:[RoomManagedModel] = [];
    var boldRoomId = ""
    
    
    @IBOutlet weak var tableView: UITableView!

    //var userArrayList:NSMutableArray = [];
    var rooms = Dictionary<String, NSMutableArray>();
    let downloader = ImageDownloader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"

        var createNewBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createNewBtnClick:")
        ApplicationManager.isLoggedIn = true;
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if(appDelegate.pendingNotification != nil){
            NotificationHelper.createPopupMessage(appDelegate, userInfo: appDelegate.pendingNotification!)
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

        getRoomsFromManagedObjects();
        initRooms();
        initProfile();

        /*
        if(!hasProfileImage()){
            loadProfileImage()
        }*/

        initDownloadProfile()
        initTableViewSettings()

    }
    
    func initTableViewSettings(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            //okay...
            self?.getRoomsFromManagedObjects()
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
                
                print("errr \(JSON)")
                
                PersonalUserModel.updateUserFromLogin(user.email, password: user.password, serverReturnedData: JSON)

                if(!self.hasProfileImage()){
                    self.loadProfileImage()
                }else{
                    self.initProfile()
                }
            }
        });
        
    }
    
    func loadProfileImage(){
        let vc = ProfileImageUploadViewController(nibName: "ProfileImageUploadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true )
    }
    
    func initProfile(){

        dispatch_async(dispatch_get_main_queue()) {
            var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
            var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + user.avatarOriginal
            var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)

            ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
                if let image = response.result.value {
                    ApplicationManager.userData.profileImage = image
                }
            }
        }
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
        self.data = RoomManagedModel.getAll()
        self.tableView.reloadData()
    }

    func initRooms(){

        //self.data = []
            
        RoomApiHelper.getRooms({
            (JSON) in

            LeaveRoomHelper.removeRoom(JSON["rooms"])
            
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["rooms"] {
                

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
                        self.getRoomsFromManagedObjects()
                    })

                    
                });
            }
            
            self.tableView.dg_stopLoading()
        },error: {
                (message, errorCode) in
            
                if(errorCode < 0){
                    UserApiHelper.updateToken({
                        //things are updated... so now call the send message again..
                        self.initRooms()
                        }, error: {
                            (errorMsg) in
                            AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                    })
                }else{
                    self.tableView.dg_stopLoading()
                }
            
            }
        );

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
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReadMessageTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:ReadMessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ReadMessageTableViewCell")! as! ReadMessageTableViewCell
        var roomData:RoomManagedModel = data[indexPath.row] as! RoomManagedModel
        
        if self.boldRoomId == roomData.roomId{
            cell?.setUnread()
        }else{
            cell?.setNormal()
        }

        cell?.populate(roomData)
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //get all user ids..?

        var roomData:RoomManagedModel = data[indexPath.row]
        let vc = MapRadialViewController(nibName: "ChatThreadViewController", bundle: nil)

        vc.chatRoomTitle = roomData.attributes.name
        vc.roomId = roomData.roomId
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = true
        
        print("okokawef: \(roomData.attributes.name)")
        
        self.boldRoomId = "";
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        navigationController?.pushViewController(vc, animated: true )
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
