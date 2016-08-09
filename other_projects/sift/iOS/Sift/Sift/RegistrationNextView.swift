//
//  RegistrationNextView.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/17/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit


protocol RegistrationNextDelegate {
    func nextField()
}


class RegistrationNextView: UIView {
    
    var delegate:RegistrationNextDelegate?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        print("Registration next vieww")
        
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }

    @IBAction func btnNextTouchUp(sender: AnyObject) {
        delegate?.nextField()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
