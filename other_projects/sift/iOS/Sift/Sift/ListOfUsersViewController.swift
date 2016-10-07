//
//  ListOfUsersViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/6/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UsersInRoomDelegate {
    func clickUser(userId:String)
}

class ListOfUsersViewController: UIViewController {
    
    var delegate:UsersInRoomDelegate?
    var roomId:String = ""
    var timerGetLocations:NSTimer?
    
    
    var data:NSMutableArray = []
    var meetupLocations:NSMutableArray = []
    var userLocations:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initUsers(){
        if(roomId != ""){
            //start the
            
            self.tableView.registerNib(UINib(nibName: "UserListTableViewCell", bundle:nil), forCellReuseIdentifier: "UserListTableViewCell")
            
            
            timerUpdateUsers()
            timerGetLocations = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "timerUpdateUsers", userInfo: nil, repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func timerUpdateUsers(){

        LocationApiHelper.getRoomLocations(self.roomId,resultJSON:{
            (JSON) in
                //self.data.removeAllObjects()
                var listChanged:Bool = false
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["user_locations"] {

                    var userLocation:UserLocationModel = UserLocationModel(json: subJson, _isPerson:true);
                    
                    
                    var userInList = self.getUser(userLocation.deviceId, userId: userLocation.userId)
                    
                    if (userInList != nil){
                        userInList?.longitude = userLocation.longitude
                        userInList?.latitude = userLocation.latitude
                    }else{
                        listChanged = true;
                        self.data.addObject(userLocation)
                    }
                }
            
                if(listChanged){
                    self.tableView.reloadData()
                }
            
            },error:{
                (String, errorCode) in
                
                print("error \(String)")
            }
            
        );
    }
    
    func updateUserValues(){
        
    }
    
    func getUser(deviceId:String, userId:String)->UserLocationModel?{
        for obj in data {
            
            if let userLocation = obj as? UserLocationModel{
                if(userLocation.deviceId == deviceId && userLocation.userId == userId){
                    return userLocation;
                }
            }else{
                //then meetup points...
            }
        }
        
        return nil;
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserListTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserListTableViewCell")! as! UserListTableViewCell
        
        var obj:AnyObject = data[indexPath.row] as AnyObject
        
        if let userData = obj as? UserLocationModel{
            print("hehehe")
        }else{
            
        }
        
        
        var userLocation:UserLocationModel;
        userLocation = data[indexPath.row] as! UserLocationModel
        
        cell?.populate(userLocation)
        
        return cell!
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnAddUserClick(sender: AnyObject) {
    
        delegate?.clickUser("fuck boi")
    }
}
