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


class DashboardViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var data:[RoomManagedModel] = [];
    @IBOutlet weak var tableView: UITableView!

    //var userArrayList:NSMutableArray = [];
    var rooms = Dictionary<String, NSMutableArray>();
    let downloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var createNewBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createNewBtnClick:")

        createNewBtn.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)
        self.navigationItem.rightBarButtonItem = createNewBtn
        self.tableView.registerNib(UINib(nibName: "ReadMessageTableViewCell", bundle:nil), forCellReuseIdentifier: "ReadMessageTableViewCell")
        self.navigationController!.navigationBar.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        getRoomsFromManagedObjects();
        initRooms();
        initProfile();

        if(!hasProfileImage()){
            loadProfileImage()
        }
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
            URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData

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
        
        dispatch_async(dispatch_get_main_queue()) {
            
            RoomApiHelper.getRooms(1, resultJSON:{
                (JSON) in

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
            });
        }
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
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReadMessageTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:ReadMessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ReadMessageTableViewCell")! as! ReadMessageTableViewCell
        var roomData:RoomManagedModel = data[indexPath.row] as! RoomManagedModel

        cell?.populate(roomData)
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //get all user ids..?

        var roomData:RoomManagedModel = data[indexPath.row]
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        

        vc.chatRoomTitle = roomData.attributes.name
        vc.roomId = roomData.roomId
        vc.hidesBottomBarWhenPushed = true
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
