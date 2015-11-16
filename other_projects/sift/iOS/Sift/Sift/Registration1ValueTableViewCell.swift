//
//  RegistrationValueTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/15/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol Registration1Delegate {
    func nextRegistration()
}

class Registration1ValueTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var delegate:Registration1Delegate?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(){
    }
    
    @IBAction func btnNextTouchUp(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.nextRegistration()
        }
    }
    
    class func cellHeight()->CGFloat{
        return 293;
    }
}
