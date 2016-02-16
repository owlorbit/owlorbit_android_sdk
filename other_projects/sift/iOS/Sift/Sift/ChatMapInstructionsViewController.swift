//
//  ChatMapInstructionsViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/25/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class ChatMapInstructionsViewController: UIViewController {

    var routeSteps = [MKRouteStep]()
    var userAnnotation:UserPointAnnotation = UserPointAnnotation();
    var customMeetupPin:CustomMeetupPin = CustomMeetupPin()
    
    var customMeetupPinActive:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userModel = userAnnotation.userModel{
            self.title = "Directions to " + userModel.firstName.capitalizedString
            customMeetupPinActive = false
        }else{
            customMeetupPinActive = true
        }
        
        // Do any additional setup after loading the view.
        
        
        var rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Launch Map", style: UIBarButtonItemStyle.Plain, target: self, action: "btnLoadMap:")
        
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        self.tableView.registerNib(UINib(nibName: "MapInstructionsTableViewCell", bundle:nil), forCellReuseIdentifier: "MapInstructionsTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnLoadMap(sender: AnyObject){
        
        AlertHelper.createPopupMessage("It will be implemented...", title: "Derp Derp")
        /*
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            
            if(customMeetupPinActive){
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?center=\(customMeetupPin.coordinate.latitude),\(customMeetupPin.coordinate.latitude)&zoom=14&views=traffic")!)
            }else{
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?center=\(customMeetupPin.coordinate.latitude),\(customMeetupPin.coordinate.latitude)&zoom=14&views=traffic")!)
            }
            
        } else {
            print("Can't use comgooglemaps://");
        }*/
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MapInstructionsTableViewCell.cellHeight();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MapInstructionsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("MapInstructionsTableViewCell")! as! MapInstructionsTableViewCell
        var mkRouteStep:MKRouteStep = routeSteps[indexPath.row] as MKRouteStep
        
        if(indexPath.row == 0){
            cell?.populateFirstCell(mkRouteStep)
        }else{
            cell?.populate(mkRouteStep)
        }

        return cell!
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
