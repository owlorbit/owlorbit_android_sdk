//
//  RegistrationValueTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/15/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol Registration1Delegate {
    func nextRegistration(registrationUser:RegistrationUser)
}

class Registration1ValueTableViewCell: UITableViewCell, RegistrationNextDelegate, RegistrationSubmitKeyboardViewDelegate {

    @IBOutlet weak var lblRetypePassword: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var keyboardNextView:RegistrationNextView?;
    var registrationSubmitKeyboardView:RegistrationSubmitKeyboardView?;
    var delegate:Registration1Delegate?;
    var registrationUser:RegistrationUser?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(){
        registrationUser = RegistrationUser()
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

        keyboardNextView = NSBundle.mainBundle().loadNibNamed("RegistrationNextView", owner: self, options:nil)[0] as! RegistrationNextView
        keyboardNextView?.delegate = self

        registrationSubmitKeyboardView = NSBundle.mainBundle().loadNibNamed("RegistrationSubmitKeyboardView", owner: self, options:nil)[0] as! RegistrationSubmitKeyboardView
        registrationSubmitKeyboardView?.delegate = self

        txtEmail.inputAccessoryView = keyboardNextView
        txtPhoneNumber.inputAccessoryView = keyboardNextView
        txtPassword.inputAccessoryView = keyboardNextView
        txtRePassword.inputAccessoryView = registrationSubmitKeyboardView
        
        txtEmail.becomeFirstResponder()
    }
    
    func submitFields(){
        if(!FormValidateHelper.isValidEmail(txtEmail.text!)){
            AlertHelper.createPopupMessage("Email is not valid!", title: "Error")
            return
        }
        
        if(txtPassword.text != txtRePassword.text){
            AlertHelper.createPopupMessage("Passwords do not match!", title: "Error")
            return
        }
        
        if txtPassword.text!.isEmpty{
            AlertHelper.createPopupMessage("Password is empty!", title: "Error")
            return
        }
        
        registrationUser?.email = txtEmail.text!
        registrationUser?.phoneNumber = txtPhoneNumber.text!
        registrationUser?.password = txtPassword.text!
        
        
        print("hello>> \(registrationUser)")
        delegate?.nextRegistration(registrationUser!)
    }

    func nextField() {

        if(txtEmail.isFirstResponder()){
            txtPhoneNumber.becomeFirstResponder()
        }else if(txtPhoneNumber.isFirstResponder()){
            txtPassword.becomeFirstResponder()
        }else if(txtPassword.isFirstResponder()){
            txtRePassword.becomeFirstResponder()
        }
    }
        
    
    @IBAction func goClick(sender: AnyObject) {
        submitFields()
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
    
    class func cellHeight()->CGFloat{
        return 293;
    }
}
