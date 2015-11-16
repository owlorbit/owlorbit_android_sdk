//
//  RegistrationValueTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/15/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol RegistrationBasicInfoDelegate {
    func submitRegistration()
}

class RegistrationBasicInfoValueTableViewCell: UITableViewCell {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    
    var delegate:RegistrationBasicInfoDelegate?;
    
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
    
    @IBAction func btnSubmitTouchUp(sender: AnyObject) {
        
    }
    
    /*
    @IBAction func btnNextTouchUp(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.submitRegistration()
        }
    }*/
    
    class func cellHeight()->CGFloat{
        return 175;
    }
}
