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
        
        /*let button = UIButton(type: .Custom)
        button.setTitle("Next", forState: .Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 5, width: self.bounds.size.width, height: 30)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right

        let view = UIView(frame: CGRectMake(0, 0, self.bounds.size.width, 40))
        view.backgroundColor = UIColor(red: 198.0/255.0, green: 190.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        view.addSubview(button)

        txtFirstName.inputAccessoryView = view*/
        
        //let registrationView:RegistrationNextView = RegistrationNextView()

        
        //SetupKeyboardAccessoryView *accessoryView = [[[NSBundle mainBundle] loadNibNamed:@"SetupKeyboardAccessoryView" owner:nil options:nil] firstObject]
        

        
        txtFirstName.inputAccessoryView = NSBundle.mainBundle().loadNibNamed("RegistrationNextView", owner: self, options:nil)[0] as! UIView
    }
    
    func loginClick(){
        print("implement");
    }
    
    func buttonAction(sender:AnyObject){
        print("yoloo")
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
