//
//  AddMeetupView.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/12/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

protocol AddMeetupDelegate {
    func addMeetup(title:String, subtitle:String, global:Bool)
    func cancelMeetup()
}

class AddMeetupView: UIView {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var swGlobal: UISwitch!
    @IBOutlet weak var txtSubtitle: UITextField!

    var delegate:AddMeetupDelegate?;
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("This class does not support NSCoding")
    }

    func dismissKeyboard(){
        txtTitle.resignFirstResponder()
        txtSubtitle.resignFirstResponder()
    }
    
    @IBAction func btnCreateClick(sender: AnyObject) {
        if(txtTitle.text != ""){
            delegate?.addMeetup(txtTitle.text!, subtitle: txtSubtitle.text!, global: swGlobal.on)
        }else{
            AlertHelper.createPopupMessage("Please name your meetup point!", title: "")
        }
        dismissKeyboard()
    }

    @IBAction func btnCancelClick(sender: AnyObject) {
        delegate?.cancelMeetup()
    }
    
    func dismissViewElements(gesture: UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    @IBAction func txtSubTitleOnSubmit(sender: AnyObject) {

        if(txtTitle.text != ""){
            delegate?.addMeetup(txtTitle.text!, subtitle: txtSubtitle.text!, global: swGlobal.on)
            dismissKeyboard()
        }else{
            AlertHelper.createPopupMessage("Please name your meetup point!", title: "")
        }
    }
    
    @IBAction func txtTitleOnReturn(sender: AnyObject) {
        txtSubtitle.becomeFirstResponder()
    }

    public static func initView()->AddMeetupView{
        var view:AddMeetupView = NSBundle.mainBundle().loadNibNamed("AddMeetupView", owner: self, options: nil)[0] as! AddMeetupView
        
        var dismissTap = UITapGestureRecognizer(target: view, action: Selector("dismissViewElements:"))
        view.addGestureRecognizer(dismissTap)

        return view;
    }
}
