//
//  ApplicationManager.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class ApplicationManager: NSObject {
    static let shareCoreDataInstance = CoreDataHelper()
    static let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    static let userData = DynamicPersonData()
}