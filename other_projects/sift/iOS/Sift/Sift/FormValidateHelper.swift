//
//  FormValidateHelper.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//


import Foundation

class FormValidateHelper{
    

    class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var result = emailTest.evaluateWithObject(testStr)

        return result
        
    }

    class func isValidPhoneNumber(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        var result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }


}