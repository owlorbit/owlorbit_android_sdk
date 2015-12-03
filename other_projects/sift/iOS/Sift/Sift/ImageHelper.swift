//
//  ImageHeper.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/2/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import Photos

class ImageHelper: NSObject {
    
    class func getAssetThumbnail(asset: PHAsset, widthHeight:CGFloat) -> UIImage {

        let manager = PHImageManager.defaultManager()
        var option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true

        manager.requestImageForAsset(asset, targetSize: CGSize(width: widthHeight, height: widthHeight), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}