//
//  EncryptUtil.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/22/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation


class EncryptUtil: NSObject {

    class func encryptSessionToken(sessionToken:String, publicKey:String, privateKey:String) -> String{

        let sessionData = sessionToken.dataUsingEncoding(NSUTF8StringEncoding)
        var encryptedPublic:NSData = RNCryptor.encryptData(sessionData!, password: publicKey)
        var base64EncodedPublic:NSData = encryptedPublic.base64EncodedDataWithOptions([])
        var encryptedPrivate = RNCryptor.encryptData(base64EncodedPublic, password: privateKey)
        var base64Encoded:String = encryptedPrivate.base64EncodedStringWithOptions([])

        return base64Encoded
    }
    
    class func test(){
        var sessionToken = "8f9044f5c8b4e3e3a289cdea60f3919f0f37dc2c4ede8131e11781214d02c2aa"
        var publicKey = "dc3db1715337d4451943f43cf9bf073164a17609c97006ec04970117037f121d"
        var privateKey = "b2c3db857382d728387c505b97616584b29ecf85f911fd4408e55c94aca9169f"
        
        let sessionData = sessionToken.dataUsingEncoding(NSUTF8StringEncoding)
        var encryptedPublic:NSData = RNCryptor.encryptData(sessionData!, password: publicKey)
        var base64EncodedPublic:NSData = encryptedPublic.base64EncodedDataWithOptions([])
        var encryptedPrivate = RNCryptor.encryptData(base64EncodedPublic, password: privateKey)
        var base64Encoded:String = encryptedPrivate.base64EncodedStringWithOptions([])

        print(EncryptUtil.sha256(sessionToken.dataUsingEncoding(NSUTF8StringEncoding)!))
        
        print ("aaa:: \(encryptSessionToken(sessionToken, publicKey: publicKey, privateKey: privateKey))")
    }

    class func sha256(data : NSData) -> String {
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        var hashStr:String = res.description

        hashStr = hashStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        hashStr = hashStr.stringByReplacingOccurrencesOfString("<", withString: "")
        hashStr = hashStr.stringByReplacingOccurrencesOfString(">", withString: "")
        return hashStr
    }
}