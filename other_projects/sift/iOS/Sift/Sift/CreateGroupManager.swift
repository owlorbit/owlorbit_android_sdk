//
//  CreateGroupManager.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/9/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class CreateGroupManager: NSObject {
    static let sharedInstance = CreateGroupManager()
    
    static var roomName:String = ""
    static var isPublic:Bool = true
    static var isFriendsOnly:Bool = true
}
