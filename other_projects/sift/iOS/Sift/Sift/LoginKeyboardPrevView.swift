//
//  RegistrationNextView.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/17/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit


protocol LoginKeyboardPrevDelegate {
    func prevField()
    func login()
}


class LoginKeyboardPrevView: UIView {
    
    var delegate:LoginKeyboardPrevDelegate?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }

    @IBAction func btnLoginClick(sender: AnyObject) {
        delegate?.login()
    }
    @IBAction func btnNextTouchUp(sender: AnyObject) {
        delegate?.prevField()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
