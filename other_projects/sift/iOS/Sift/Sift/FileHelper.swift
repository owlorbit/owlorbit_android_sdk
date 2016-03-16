//
//  FileHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 3/6/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation

class FileHelper{
    
    
    class func getUserImage(userId:String, completion: ((data: NSData?, error: NSError? ) -> Void)) {

        let filePath = getDocumentsDirectory().stringByAppendingPathComponent(userId + ".png")
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(fileURLWithPath: filePath)) { (data, response, error) in
            completion(data: data, error: error)
            }.resume()
    }
    
    class func getRoundUserImage(userId:String, completion: ((data: NSData?, error: NSError? ) -> Void)) {
        
        let filePath = getDocumentsDirectory().stringByAppendingPathComponent(userId + "-round.png")
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(fileURLWithPath: filePath)) { (data, response, error) in
            completion(data: data, error: error)
            }.resume()
    }

    class func saveImage(image:UIImage, fileName:String){
        //if let data = UIImagePNGRepresentation(image) {
        if let data = UIImageJPEGRepresentation(image, 100) {
            let filePath = getDocumentsDirectory().stringByAppendingPathComponent(fileName)
            data.writeToFile(filePath, atomically: true)
        }
    }
    
    class func saveRoundImage(var image:UIImage, fileName:String){

        image = image.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
        image = image.roundImage()
        if let data = UIImagePNGRepresentation(image) {
            let filePath = getDocumentsDirectory().stringByAppendingPathComponent(fileName)
            data.writeToFile(filePath, atomically: true)
        }
    }
    
    class func saveRoundImageConverted(var image:UIImage, fileName:String){
        
        if let data = UIImagePNGRepresentation(image) {
            let filePath = getDocumentsDirectory().stringByAppendingPathComponent(fileName)
            data.writeToFile(filePath, atomically: true)
        }
    }
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
