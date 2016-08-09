//
//  RegistrationSubmitKeyboardView.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/18/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol RegistrationSubmitKeyboardViewDelegate {
    func submitFields()
}


class RegistrationSubmitKeyboardView: UIView {
    
    var delegate:RegistrationSubmitKeyboardViewDelegate?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        print("Registration submit vieww")
        
    }

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        delegate?.submitFields()
    }

}