//
//  RegistrationValueTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/15/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol RegistrationBasicInfoWitheBetaValueDelegate {
    func submitRegistration(firstName:String, lastName:String, betaCode:String)
}

class RegistrationBetaTableViewCell: UITableViewCell, RegistrationNextDelegate, RegistrationSubmitKeyboardViewDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtBetaCode: UITextField!
    
    var delegate:RegistrationBasicInfoWitheBetaValueDelegate?;
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
        txtLastName.inputAccessoryView = keyboardNextView
        txtBetaCode.inputAccessoryView = registrationSubmitKeyboardView
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
            AlertHelper.createPopupMessage("First Name is empty!", title: "Error")
            return
        }
        
        if txtLastName.text!.isEmpty{
            AlertHelper.createPopupMessage("Last Name is empty!", title: "Error")
            return
        }

        if(txtBetaCode.text!.isEmpty){
            AlertHelper.createPopupMessage("Promo is empty!", title: "Error")
            return
        }

        delegate?.submitRegistration(txtFirstName.text!, lastName: txtLastName.text!, betaCode: txtBetaCode.text!)
    }

    @IBAction func goClick(sender: AnyObject) {
        submitFields()
    }

    /*
    @IBAction func btnNextTouchUp(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.submitRegistration()
        }
    }*/
    
    class func cellHeight()->CGFloat{
        return 217;
    }
}
