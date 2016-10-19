//
//  AddMeetupView.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/12/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

protocol UserAnnotationViewDelegate {
    //func addMeetup(title:String, subtitle:String, global:Bool)
    //func addMeetupFromAddress(customFindAddressPin:CustomFindAddressPin, title:String, subtitle:String, global:Bool)
    func cancelMeetup()
}

class UserAnnotationView: MKAnnotationView {

    @IBOutlet weak var btnZoom: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate:UserAnnotationViewDelegate?;

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
        //txtTitle.resignFirstResponder()
        //txtSubtitle.resignFirstResponder()
    }

    
    func dismissViewElements(gesture: UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    func initialize(){
        //btnZoom.addTarget(self, action: #selector(self.calloutButtonClicked), forControlEvents: .TouchUpInside)

        
        let button:UIButton = UIButton(frame: CGRectMake(100, 0, 100, 40))
        button.setTitle("more info", forState: .Normal)
        button.setTitleColor(UIColor(red: 0.3254, green: 0.5843, blue: 0.9019, alpha: 1.0), forState: .Normal)
        button.addTarget(self, action: #selector(self.calloutButtonClicked), forControlEvents: .TouchUpInside)
        addSubview(button)
        
        //button.userInteractionEnabled = true
        //self.btnZoom.userInteractionEnabled = true;
        //self.userInteractionEnabled = true
    }

    func calloutButtonClicked() {
        //var annotation = self.annotation
        //self.delegate.calloutButtonClicked((annotation.title as! String))
        print("come on")
        AlertHelper.createPopupMessage("awfe", title: "theology")
    }
    
    
    public static func initView()->UserAnnotationView{
        var view:UserAnnotationView = NSBundle.mainBundle().loadNibNamed("UserAnnotationView", owner: self, options: nil)[0] as! UserAnnotationView
        
        //var dismissTap = UITapGestureRecognizer(target: view, action: Selector("dismissViewElements:"))
        //view.addGestureRecognizer(dismissTap)

        return view;
    }
}
