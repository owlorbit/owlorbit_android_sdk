//
//  BetaInviteViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/12/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit
import Social
import SwiftyJSON

class BetaInviteViewController: UIViewController {

    @IBOutlet weak var lblInviteCount: UILabel!
    @IBOutlet weak var lblBetaCode: UILabel!

    var betaCode:String = ""
    var inviteCount:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Beta Invite"
        
        self.lblInviteCount.text = ""
        self.lblBetaCode.text = ""
        getInvite()
        
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.Plain, target: self, action: "btnShareClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.classForCoder))
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    func btnShareClick(sender: AnyObject){
        
        if(betaCode == ""){
            AlertHelper.createPopupMessage("You do not have a working code!", title: "Error")
        }else{
            
            let alert = UIAlertController(title: "Share", message: "Share your beta code with a friend!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let oneAction = UIAlertAction(title: "Twitter", style: .Default) { (_) in
                self.shareWithTwitter()
            }
            let twoAction = UIAlertAction(title: "Facebook", style: .Default) {
                (_) in
                self.shareWithFacebook()
            }
            let threeAction = UIAlertAction(title: "Email", style: .Default) { (_) in
                self.shareWithEmail()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            
            alert.addAction(oneAction)
            alert.addAction(twoAction)
            alert.addAction(threeAction)
            alert.addAction(cancelAction)

            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareWithFacebook(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Please sign up for Owlorbit.  Download the app visiting https://owlorbit.com then use my promo-code \(betaCode)")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func shareWithTwitter(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Please sign up for Owlorbit.  Download the app visiting https://owlorbit.com then use my promo-code \(betaCode)")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareWithEmail(){
        // text to share
        let textToShare = "Please sign up for Owlorbit using my promo-code \(betaCode)"
        
        // url to share, if any
        let urlToShare = NSURL(string: "https://owlorbit.com")
        
        // place the items to share in an array of type AnyObject
        let objectsToShare: [AnyObject] = [textToShare, urlToShare!]
        
        // initialize the controller that will show the share options
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // exclude some activities that are irrelevant to your app,        
        
        // show the share options view
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
    func getInvite(){
            FullScreenLoaderHelper.startLoader()
        
        
        var delayInSeconds:Float = 0.5;
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),  Int64(  0.5 * Double(NSEC_PER_SEC)  ))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            
            
            BetaApiHelper.getCode({
                (JSON) in
                
                    self.inviteCount = JSON["betaInvite"]["invite_count"].string!
                    self.betaCode = JSON["betaInvite"]["code"].string!
                
                    if(Int(self.inviteCount) > 0){
                        self.lblInviteCount.text = "You have \(self.inviteCount) invites left."
                        self.lblBetaCode.text = self.betaCode
                    }else{
                        self.lblInviteCount.text = "You have no invites left!"
                        self.lblBetaCode.text = "No Beta Code"
                    }
                
                
                    FullScreenLoaderHelper.removeLoader();
                
                },error: {
                    (message, errorCode) in

                    FullScreenLoaderHelper.removeLoader();
                    if(errorCode < 0){
                        UserApiHelper.updateToken({
                            //things are updated... so now call the send message again..
                            self.getInvite()
                            }, error: {
                                (errorMsg) in
                                AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                        })
                    }
                }
            );
        
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
