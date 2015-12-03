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

class DashboardViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var data:NSMutableArray = [];
    @IBOutlet weak var tableView: UITableView!

    //var userArrayList:NSMutableArray = [];
    var rooms = Dictionary<String, NSMutableArray>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        //navigationController?.pushViewController(vc, animated: true )
        //data.addObject("a")
        var createNewBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createNewBtnClick:")
        
        createNewBtn.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)
        self.navigationItem.rightBarButtonItem = createNewBtn
        
        self.tableView.registerNib(UINib(nibName: "ReadMessageTableViewCell", bundle:nil), forCellReuseIdentifier: "ReadMessageTableViewCell")


        self.navigationController!.navigationBar.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)

        initRooms();
        if(!hasProfileImage()){
            let vc = ProfileImageUploadViewController(nibName: "ProfileImageUploadViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true )
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
    
    func initRooms(){
        RoomApiHelper.getRooms(1, resultJSON:{
            (JSON) in

            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["rooms"] {
                var roomModel:RoomModel = RoomModel(json: subJson);

                if(self.rooms[roomModel.roomId] == nil){
                    //print("adding: \(roomModel.roomId)")
                    self.rooms[roomModel.roomId] = NSMutableArray();
                }

                self.rooms[roomModel.roomId]?.addObject(roomModel)
            }

            for (key, roomArr) in self.rooms {
                var roomId:String = key as! String
                var roomCell:RoomCellModel = RoomCellModel(data: roomArr, roomId: roomId)
                self.data.addObject(roomCell)
            }
            
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.reloadData()
        });
    }
    
    func createNewBtnClick(sender: AnyObject){
        //WriteMessageViewController

        let vc = WriteMessageViewController(nibName: "WriteMessageViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTest(sender: AnyObject) {
        
        //print("why no push..?")
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
        var roomCellModel:RoomCellModel = data[indexPath.row] as! RoomCellModel

        cell?.populate(roomCellModel)
        //cell.populate(data[indexPath.row])
        //cell.textLabel?.text = self.data[indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var roomCellModel:RoomCellModel = data[indexPath.row] as! RoomCellModel
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.chatRoomTitle = roomCellModel.name
        vc.userIds = roomCellModel.userIds
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
