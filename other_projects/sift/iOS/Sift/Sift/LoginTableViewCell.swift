//
//  LoginTableViewCell.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/16/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func startRegistration()
    func signIn(username: String, password: String)
}

class LoginTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    var delegate:LoginDelegate?;

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnSignUpTouchUp(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.signIn(txtEmail.text!, password: txtPassword.text!)
        }
    }

    @IBAction func btnRegisterTouchUp(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.startRegistration()
        }
    }
    
    func populate(){
        txtEmail.becomeFirstResponder()
        
        if(PersonalUserModel.get().count > 0){
            var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
            //print(user.firstName)
            txtEmail.text = user.email
            txtPassword.text = user.password
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func cellHeight()->CGFloat{
        return 167;
    }
        
}
