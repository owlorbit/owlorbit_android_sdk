//
//  ApplicationManager.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import ALThreeCircleSpinner

import Alamofire
import AlamofireImage.Swift

class ApplicationManager: NSObject {
    static let shareCoreDataInstance = CoreDataHelper()
    static let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    
    static var parseDeviceId:String = "dfb741cef2357eb03ec423db038aaa0ccf9188a58d5639cae60029859a0da74e"
    static let userData = DynamicPersonData()
    static let downloader = ImageDownloader()
    //spinners.
    static var spinner = ALThreeCircleSpinner(frame: CGRectMake(0,0,44,44))
    static var spinnerBg:UIView = UIView(frame: ((UIApplication.sharedApplication().delegate?.window)!)!.frame)
}