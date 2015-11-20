//
//  RegistrationValueTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/15/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol RegistrationBasicInfoDelegate {
    func submitRegistration(firstName:String, lastName:String)
}

class RegistrationBasicInfoValueTableViewCell: UITableViewCell, RegistrationNextDelegate, RegistrationSubmitKeyboardViewDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    var delegate:RegistrationBasicInfoDelegate?;
    var keyboardNextView:RegistrationNextView?;
    var registrationSubmitKeyboardView:RegistrationSubmitKeyboardView?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func nextField() {
        txtLastName.becomeFirstResponder()
    }
    
    func populate(){

        keyboardNextView = NSBundle.mainBundle().loadNibNamed("RegistrationNextView", owner: self, options:nil)[0] as! RegistrationNextView
        keyboardNextView?.delegate = self
        
        registrationSubmitKeyboardView = NSBundle.mainBundle().loadNibNamed("RegistrationSubmitKeyboardView", owner: self, options:nil)[0] as! RegistrationSubmitKeyboardView
        registrationSubmitKeyboardView?.delegate = self
        
        txtFirstName.inputAccessoryView = keyboardNextView
        txtLastName.inputAccessoryView = registrationSubmitKeyboardView
        txtFirstName.becomeFirstResponder()
    }
    
    func loginClick(){
        print("implement");
    }
    
    func buttonAction(sender:AnyObject){
        print("yoloo")
    }
    
    func submitFields(){
        

        if txtFirstName.text!.isEmpty{
            AlertHelper.createPopupMessage("Password is empty!", title: "Error")
            return
        }
        
        if txtLastName.text!.isEmpty{
            AlertHelper.createPopupMessage("Password is empty!", title: "Error")
            return
        }
        
        delegate?.submitRegistration(txtFirstName.text!, lastName: txtLastName.text!)
        
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
