//
//  MessageModel.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/3/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class MessageModel :  NSObject, JSQMessageData {
    
    var senderId_ : String!
    var senderDisplayName_ : String!
    var date_ : NSDate
    var isMediaMessage_ : Bool
    var messageHash_ : Int  = 0
    var text_ : String
  
    
    init(senderId: String, senderDisplayName: String?, isMediaMessage: Bool, messageHash:Int, text: String) {
        self.senderId_ = senderId
        self.senderDisplayName_ = senderDisplayName
        self.date_ = NSDate()
        self.isMediaMessage_ = isMediaMessage
        self.messageHash_ = messageHash
        self.text_ = text
    }
    
    func senderId() -> String! {
        return senderId_;
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_;
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_;
    }
        
    func messageHash() -> UInt {
        return UInt(messageHash_);
    }

    
    func text() -> String! {
        return text_;
    }
    
    
    
}