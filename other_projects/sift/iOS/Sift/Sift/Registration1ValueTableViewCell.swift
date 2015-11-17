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
    
    

    @IBOutlet weak var lblRetypePassword: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
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
        
        let tapEmailLbl: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "giveEmailFocus")
        tapEmailLbl.numberOfTapsRequired = 1;
        lblEmail.userInteractionEnabled = true;
        lblEmail.addGestureRecognizer(tapEmailLbl)
        
        let tapPhoneNumberLbl: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "givePhoneNumberFocus")
        tapPhoneNumberLbl.numberOfTapsRequired = 1;
        lblPhoneNumber.userInteractionEnabled = true;
        lblPhoneNumber.addGestureRecognizer(tapPhoneNumberLbl)

        let tapPasswordLbl: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "givePasswordFocus")
        tapPasswordLbl.numberOfTapsRequired = 1;
        lblPassword.userInteractionEnabled = true;
        lblPassword.addGestureRecognizer(tapPasswordLbl)

        let tapRePasswordLbl: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "giveRePasswordFocus")
        tapRePasswordLbl.numberOfTapsRequired = 1;
        lblRetypePassword.userInteractionEnabled = true;
        lblRetypePassword.addGestureRecognizer(tapRePasswordLbl)
        
    }
    
    func giveRePasswordFocus(){
        txtRePassword.becomeFirstResponder()
    }
    
    func givePasswordFocus(){
        txtPassword.becomeFirstResponder()
    }
    
    func givePhoneNumberFocus(){
        txtPhoneNumber.becomeFirstResponder()
    }
    
    func giveEmailFocus(){
        txtEmail.becomeFirstResponder()
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
