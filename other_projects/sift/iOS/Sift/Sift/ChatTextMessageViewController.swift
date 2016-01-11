//
//  TestMessageViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/21/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftDate
import SwiftyJSON

class ChatTextMessageViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    var senderImageUrl: String!
    
    
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    var blankAvatarImage: JSQMessagesAvatarImage!    
    var roomId:String = ""

    var pageIndex:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        self.senderId = user.userId
        
        self.senderDisplayName = user.firstName
        senderImageUrl = ""
        //sender = (sender != nil) ? sender : "Anonymous"
        
        var bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleRedColor())
        
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "owl_orbit"), diameter: 30)
        // Do any additional setup after loading the view.

        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        loadInitMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!
        , date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()

        //var message: MessageModel = MessageModel(messageId: "", senderId: senderId, senderDisplayName: senderDisplayName, isMediaMessage: false, date: date, roomId: roomId , text: text)
        var message: JSQMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        messages.append(message)

        var messageCore : MessageModel = MessageModel(messageId: "", senderId: senderId, senderDisplayName: senderDisplayName, isMediaMessage: false, date: date.inUTCRegion().UTCDate, roomId: roomId , text: text)
        MessageCoreModel.insertFromMessageModel(messageCore)

        var updatedDate:DateInRegion = DateInRegion(UTCDate: date.inUTCRegion().UTCDate, region: Region(tzType: TimeZoneNames.America.New_York))!
        var createdDate:String = updatedDate.toString(DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))! //prints out 10:12
            
        ChatApiHelper.sendMessage(text, roomId:roomId, created:createdDate, resultJSON: {
            (JSON) in
            print(JSON)
        })

        //add to...coredata..
        finishSendingMessage()
    }
    
    func loadInitMessages(){
        //load core data first...
        //print(">>>  OVER YOUR SHOULDER: \(MessageCoreModel.getByRoomId(roomId).count)")

        var otherDate:NSDate = NSDate()
        for object in MessageCoreModel.getByRoomId(roomId) as! [MessageCoreModel] {

            var message: JSQMessage = JSQMessage(senderId: object.userId, senderDisplayName: object.senderDisplayName, date: object.created, text: object.message)
            messages.append(message)
        }

        RoomApiHelper.getRoomMessages(roomId, pageIndex:pageIndex, resultJSON:{
            (JSON) in
            
            for (key,subJson):(String, SwiftyJSON.JSON) in JSON["messages"] {

                var created:String = subJson["created"].string!
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                var dateConverted:NSDate = dateFormatter.dateFromString(created)!

                print("DUH - \(subJson["message"].string!) - \(dateConverted.inUTCRegion().UTCDate)")


                //if(dateConverted.isEqualToDate(otherDate)){
                if(subJson["message"].string! == "Okay.."){
                    //print (dateConverted)
                }
                
//dateConverted.inUTCRegion().UTCDate.toString(DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))! + " +0000"

                if dateConverted.inUTCRegion().UTCDate.toString(DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))! + " +0000" == "2016-01-11 00:28:45 +0000" {
                    print("other date eqaul but not in coredata wtf")
                }
                
                /*
                var dateFormatter2 = NSDateFormatter()
                dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
                dateFormatter2.timeZone = NSTimeZone(abbreviation: "UTC")
                var dateConverted2:NSDate = dateFormatter2.dateFromString("2016-01-11 01:13:57.000 +0000")!
                print("Milli - \(subJson["message"].string!) - \(dateConverted2)")*/


                if(MessageCoreModel.doesMessageExist(subJson["room_id"].string!, userId: subJson["user_id"].string!, created: dateConverted.inRegion(Region.defaultRegion()).UTCDate)){
                    print("wat the actual")
                }else{
                    //print("shit face")
                    var message: JSQMessage = JSQMessage(senderId: subJson["user_id"].string, senderDisplayName: subJson["first_name"].string, date: dateConverted, text: subJson["message"].string)
                    self.messages.append(message)
                }

                //var message: JSQMessage = JSQMessage(senderId: subJson["user_id"].string, senderDisplayName: subJson["first_name"].string, date: dateConverted, text: subJson["message"].string)
                //self.messages.append(message)
                
                //print("wompppp: \(subJson)")
                /*
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
                });*/
            }
            
            self.finishSendingMessage()
        });
    }
    
    func processNotification(){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = false
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];

        // Sent by me, skip
        if message.senderId == self.senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }

        return NSAttributedString(string:message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        /*var user = self.users[indexPath.item]
        if self.avatars[user.objectId] == nil {
            var thumbnailFile = user[PF_USER_THUMBNAIL] as? PFFile
            thumbnailFile?.getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    self.avatars[user.objectId as String] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: imageData), diameter: 30)
                    self.collectionView.reloadData()
                }
            })
            return blankAvatarImage
        } else {
            return self.avatars[user.objectId]
        }*/
        
        return blankAvatarImage
    }
    ////


    
    
}
