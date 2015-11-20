//
//  AlertHelper.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

class AlertHelper{

    class func createPopupMessage(message:String, title:String){
        var alert:UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
}