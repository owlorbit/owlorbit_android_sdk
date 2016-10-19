//
//  ReadMessageTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage.Swift

class ReadMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblRoomTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populateRoomData(room:DashboardRoomModel, users:NSMutableArray){
        self.lblRoomTitle.text = room.roomName
        
        if(room.lastDisplayName != "" && room.lastMessage != "") {
            lblLastMsg.text = room.lastDisplayName + ": " + room.lastMessage
        }else{
            lblLastMsg.text = ("No messages sent yet!");
        }

        if(room.lastMessageTimestamp != "") {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
            var dateConverted:NSDate = dateFormatter.dateFromString(room.lastMessageTimestamp)!
            var timeago:String = NSDate.mysqlDatetimeFormattedAsTimeAgo(dateFormatter.stringFromDate(dateConverted))
            self.lblDate.text = timeago
        }else{
            self.lblDate.text = ""
        }
        
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var setUserId:String = "";
        
        
        var allUsers:String = "";
        var usersInRoom:NSMutableArray = getAllUsersInRoom(room.roomId, users: users)
        
        if(usersInRoom.count > 0) {
            for usr in usersInRoom as! [DashboardUserModel] {
                if(usr.userId != user.userId){
                    allUsers += usr.firstName + ", ";
                    setUserId = usr.userId
                }
            }
        }
        
        if(room.roomName == ""){

            allUsers = allUsers.trim();
            if(allUsers.characters.last! == ","){
               allUsers = allUsers.substringToIndex(allUsers.endIndex.predecessor())
            }
            lblRoomTitle.text = allUsers;
        }
        
        
        var avatarString:String = "";
        if(room.avatarOriginal == ""){
            avatarString = "/uploads/profile_imgs/" + setUserId + ".png";
        }else{
            if(room.avatarOriginal.containsString("/" + user.userId + ".png")){
                avatarString = "/uploads/profile_imgs/" + setUserId + ".png";
            }else{
                avatarString = room.avatarOriginal;
            }
        }

        let profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + avatarString
        let URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        
        ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
            if let image = response.result.value {
                self.imgAvatar.image = image.roundImage()
            }
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

    func populate(roomData:RoomManagedModel){

        self.lblRoomTitle.text = roomData.roomName
        
        if(roomData.lastDisplayName.capitalizedString.isEmpty || roomData.lastDisplayName == ""){
            self.lblLastMsg.text = "No message sent"
            self.lblLastMsg.font = self.lblLastMsg.font.italic()
        }else{
            self.lblLastMsg.text = roomData.lastDisplayName.capitalizedString + ": " + roomData.lastMessage
        }

        //self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(roomData.lastMessageTimestamp)
        if( roomData.lastMessageTimestamp != nil){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateString = dateFormatter.stringFromDate(roomData.lastMessageTimestamp!)
            
            self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(dateString)
        }else{
            self.lblDate.text = NSDate.mysqlDatetimeFormattedAsTimeAgo(roomData.timestamp)
        }
        self.lblRoomTitle.text = roomData.attributes.name.capitalizedString
        //self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
        
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
        var imageSet:Bool = false
        
        
        
        let profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + roomData.avatarOriginal
        let URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)

        ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
            
            if let image = response.result.value {
                self.imgAvatar.image = image
                //FileHelper.saveImage(image, fileName:  (userGeneric.userId + ".png") )
            }
        }
        
        
        /*
        if (roomData.attributes.users.allObjects.count > 0){
            if let userGeneric = roomData.attributes.users.allObjects[0] as? GenericUserManagedModel {
                
                
                FileHelper.getUserImage(userGeneric.userId, completion: { data,error in

                    if let imgData:NSData = data {
                        self.imgAvatar.image = UIImage(data:imgData,scale:1.0)
                        imageSet = true
                    }

                    if let err:NSError = error {
                        if (roomData.attributes.users.allObjects.count > 0){
                            if let userGeneric = roomData.attributes.users.allObjects[0] as? GenericUserManagedModel {
                                
                                let profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + userGeneric.avatarOriginal
                                let URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
                                
                                ApplicationManager.downloader.downloadImage(URLRequest: URLRequest) { response in
                                    
                                    if let image = response.result.value {
                                        self.imgAvatar.image = image
                                        //FileHelper.saveImage(image, fileName:  (userGeneric.userId + ".png") )
                                    }
                                }
                            }
                        }
                        
                    }
                })
                
            }
        }*/
    }
    
    func setUnread(){

        
        self.lblLastMsg.font = self.lblLastMsg.font.bold()
        //self.lblRoomTitle.font = self.lblRoomTitle.font.bold()
    }
    
    func setNormal(){
        self.lblLastMsg.font = UIFont(name: "AvenirNext-UltraLight", size: 14)
        //self.lblRoomTitle.font = UIFont(name: "AvenirNext-Regular", size: 17)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 74.0
    }
    
}
