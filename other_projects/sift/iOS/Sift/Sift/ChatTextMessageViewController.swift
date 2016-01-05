//
//  TestMessageViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/21/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatTextMessageViewController: JSQMessagesViewController {

    
    var messages = [JSQMessage]()
    var senderImageUrl: String!
    
    
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "TIM"
        self.senderDisplayName = "TIM"
        senderImageUrl = ""
        //sender = (sender != nil) ? sender : "Anonymous"
        
        var bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "owl_orbit"), diameter: 30)
        // Do any additional setup after loading the view.
        
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!
        , date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()

        var message: JSQMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        messages.append(message)
            
            
        var message2: JSQMessage = JSQMessage(senderId: "aaa", senderDisplayName: "DERP", date: date, text: "ZIPAIOJWEF")
        messages.append(message2)

        finishSendingMessage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = true
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
