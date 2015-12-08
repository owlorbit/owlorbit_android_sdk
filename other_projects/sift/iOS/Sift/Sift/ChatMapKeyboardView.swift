//
//  ChatMapKeyboardView.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/1/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

protocol ChatSubmitDelegate {
    func submitChat()
}


class ChatMapKeyboardView: UIView {
    
    var delegate:ChatSubmitDelegate?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        print("chat next vieww")
        
    }
    
    @IBAction func btnSendClick(sender: AnyObject) {
        print("click..")
        delegate?.submitChat()
    }

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }

}