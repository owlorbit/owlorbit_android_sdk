//
//  MapRadialViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/18/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import QuartzCore
import SwiftyJSON


protocol MapRadialViewControllerDelegate {
    func didExitRoom(controller: MapRadialViewController)
}

class MapRadialViewController: ChatThreadViewController{
    

    var delegate: MapRadialViewControllerDelegate! = nil
    var displayMenu:Bool = false
    var firstLoad:Bool = true
    var tempVisibleLockTmr:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initToggleViews()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(!self.navigationController!.navigationBar.hidden){
            
            self.searchContainerConstraintTop.constant = 0;
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                
                self.bottomTxtConstraint.constant = 12
                self.LOCK_TOGGLE = false
                self.view.layoutIfNeeded()
            })
        }                

    }
    
    @IBAction override func btnMenuClick(sender: AnyObject){
        super.btnMenuClick(sender)
        
        if(displayMenu){
            
            self.btnInstructions.hidden = true
            self.btnMeetup.hidden = true
            self.btnExit.hidden = true

            displayMenu = false
        }else{

            self.btnInstructions.hidden = false
            self.btnMeetup.hidden = false
            self.btnExit.hidden = false

            displayMenu = true
        }
       
    }
    
    @IBAction override func btnExitClick(sender:AnyObject){

        // Create the alert controller
        var alertController = UIAlertController(title: "Leave Room", message: "Are you sure?", preferredStyle: .Alert)
        // Create the actions
        var okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        var cancelAction = UIAlertAction(title: "Hoo cares.  I'm out!", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
                self.leaveRoom()
            }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func leaveRoom(){
        
        
        FullScreenLoaderHelper.startLoader()
        dispatch_async(dispatch_get_main_queue()) {

            RoomApiHelper.getRooms({
                (JSON) in
                
                LeaveRoomHelper.removeRoom(JSON["rooms"])
                
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["rooms"] {
                    var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                    RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                        (JSON2) in
                        
                        
                        RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                            (roomAttribute) in
                            
                            roomModel.attributes = roomAttribute
                            if(roomModel.attributes.users.count > 0){
                                roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                            }
                            
                            ApplicationManager.shareCoreDataInstance.saveContext()
                            
                        })
                        
                        
                    });
                }
                
                
                
                RoomApiHelper.leaveRoom(self.roomId, resultJSON:
                    {
                        (JSON) in
                        
                        if let navController = self.navigationController {
                            //FullScreenLoaderHelper.removeLoader()
                            
                            /*navController.popViewControllerAnimated(true)
                            
                            if(self.delegate != nil){
                                self.delegate.didExitRoom(self)
                            }*/
                            
                            
                            RoomApiHelper.getRooms({
                                (JSON) in
                                
                                LeaveRoomHelper.removeRoom(JSON["rooms"])
                                
                                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["rooms"] {
                                    
                                    var roomModel:RoomManagedModel = RoomManagedModel.initWithJson(subJson);
                                    RoomApiHelper.getRoomAttribute(roomModel.roomId, resultJSON:{
                                        (JSON2) in
                                        
                                        
                                        RoomAttributeManagedModel.initWithJson(JSON2, roomId: roomModel.roomId, roomAttributeModel:{
                                            (roomAttribute) in
                                            
                                            roomModel.attributes = roomAttribute
                                            if(roomModel.attributes.users.count > 0){
                                                roomModel.avatarOriginal = (roomModel.attributes.users.allObjects[0] as! GenericUserManagedModel).avatarOriginal
                                            }
                                            
                                            ApplicationManager.shareCoreDataInstance.saveContext()
                                            
                                        })
                                        
                                        
                                    });
                                }
                                
                                
                                FullScreenLoaderHelper.removeLoader()
                                
                                navController.popViewControllerAnimated(true)
                                
                                if(self.delegate != nil){
                                    self.delegate.didExitRoom(self)
                                }
                                
                                },error: {
                                    (message, errorCode) in
                                    
                                   
                                    
                                }
                            );
                            
                            
                            
                            
                            
                            
                            /////////FWEF
                            
                        }
                        
                        
                    }
                    , error:{
                        (Error) in
                        AlertHelper.createPopupMessage("\(Error)", title: "")
                    }
                )
                
                
                
                },error: {
                    (message, errorCode) in
                    
                    if(errorCode < 0){
                        UserApiHelper.updateToken({
                            //things are updated... so now call the send message again..
                            self.leaveRoom()
                            }, error: {
                                (errorMsg) in
                                AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                        })
                    }
                }
            );
        }
    }
    
    @IBAction override func txtSearchOnChange(sender: AnyObject) {
        super.txtSearchOnChange(sender)
        
    }
    
    override func textFieldShouldReturn(textField: UITextField!) -> Bool {
        super.textFieldShouldReturn(textField)
        
        if(textField == self.txtChatView){
            
            self.submitChat()
            return true
        }

        //let address = "1 Infinite Loop, CA, USA"
        let address:String! = txtSearch.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
                
                AlertHelper.createPopupMessage("We could not find \(address).", title: "Not Found")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate

                var customFindAddressPin:CustomFindAddressPin = CustomFindAddressPin()
                customFindAddressPin.coordinate = coordinates

                var region:MKCoordinateRegion = MKCoordinateRegion();
                region.center.latitude = customFindAddressPin.coordinate.latitude;
                region.center.longitude = customFindAddressPin.coordinate.longitude;
                region.span.latitudeDelta = self.spanX;
                region.span.longitudeDelta = self.spanY;
                self.mapView.setRegion(region, animated: true)
                customFindAddressPin.title = address
                customFindAddressPin.subtitle = "Save this pin"
                customFindAddressPin.initAddress = address
                
                self.annotations.addObject(customFindAddressPin)
                self.mapView.addAnnotation(customFindAddressPin)
                
                self.mapView.selectAnnotation(customFindAddressPin, animated: true)
                print("hey there \(coordinates)")
            }
        })
        
        
        self.txtSearch.text = ""
        return true
    }
    
    
    func initToggleViews(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleViews")
        tap.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(tap)
        
    }
    
    func toggleViews() {
        
        
        if(txtChatView.isFirstResponder() || txtSearch.isFirstResponder()){
            self.PREV_WAS_LOCKED = true
            self.dismissKeyboard()
            return
        }else{
            self.PREV_WAS_LOCKED = false
        }

        self.dismissKeyboard()
        
        
        if(LOCK_TOGGLE){
            return
        }

        if(self.mapView.selectedAnnotations.count > 0){
            self.PREV_WAS_LOCKED = false
            return
        }
        
        LOCK_TOGGLE = true
        
        var delayInSeconds:Float = 0.5;
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),  Int64(  0.5 * Double(NSEC_PER_SEC)  ))
        dispatch_after(time, dispatch_get_main_queue()) {
            

            if(self.PREV_WAS_LOCKED){
                return
            }
            
            if(self.mapView.selectedAnnotations.count == 0){

                self.PREV_WAS_LOCKED = false
                
                var updatedPosition:CGFloat = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
                if(self.searchContainerConstraintTop.constant == 0 || self.searchContainerConstraintTop.constant == updatedPosition){
                    self.navigationController!.navigationBar.translucent = true;
                    self.navigationController!.navigationBar.hidden = true;
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
                    
                    
                    UIView.animateWithDuration(0.5, animations: {() -> Void in
                        self.searchContainerConstraintTop.constant = -150;
                        self.bottomTxtConstraint.constant = -240
                        self.LOCK_TOGGLE = false
                        self.view.layoutIfNeeded()
                    })

                }else{
                    
                    self.navigationController!.navigationBar.translucent = false;
                    self.navigationController!.navigationBar.hidden = false;
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

                    self.searchContainerConstraintTop.constant = updatedPosition;
                    UIView.animateWithDuration(0.5, animations: {() -> Void in
                        
                        self.bottomTxtConstraint.constant = 12
                        self.LOCK_TOGGLE = false
                        self.view.layoutIfNeeded()
                    })
                }
            }else{
                self.LOCK_TOGGLE = false
                self.PREV_WAS_LOCKED = true
            }
        }
    }
    
    @IBAction override func createDropActionClick(sender: AnyObject) {

        UIView.animateWithDuration(0.5, animations: {() -> Void in
            var infoFrame: CGRect = self.addMeetupView!.frame
            infoFrame.origin.y = 0.0
            self.addMeetupView!.frame = infoFrame
        })
    }

    override func btnSaveFindAddress(sender : AnnotationButton!){
        super.btnSaveFindAddress(sender)
        
        print("btn save find address launch view...")
    }
    
    func tempVisibleLockTmrUpdate(){
        print("heh")
        TEMP_VISIBLE_LOCK = false
        tempVisibleLockTmr.invalidate()
    }
    
    
    @IBAction override func btnVisibilityClick(sender: AnyObject){
        super.btnVisibilityClick(sender)
        
        
        //then start timer...
        
        if(TEMP_VISIBLE_LOCK){
            tempVisibleLockTmr = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "tempVisibleLockTmrUpdate", userInfo: nil, repeats: false)
        }

        
        
        TEMP_VISIBLE_LOCK = true
        if(isHiddenInRoom){
            if let image = UIImage(named: "btn_visible") {
                self.btnVisibility.setImage(image, forState: .Normal)
            }
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.viewGrey.alpha = 0.0
            })
            
            
            
            RoomApiHelper.setVisible(self.roomId, resultJSON:
                {
                    (JSON) in
                    
                    print("success")

                }
                , error:{
                    (Error) in
                    AlertHelper.createPopupMessage("\(Error)", title: "")
                }
            )

            
            
            
            isHiddenInRoom = false
        }else{
            
            
            if let image = UIImage(named: "btn_hidden") {
                self.btnVisibility.setImage(image, forState: .Normal)
            }

            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.viewGrey.alpha = 0.5
            })
            
            RoomApiHelper.setHidden(self.roomId, resultJSON:
                {
                    (JSON) in
                    
                    print("succ2ess \(self.roomId)")
                    
                    
                }
                , error:{
                    (Error) in
                    AlertHelper.createPopupMessage("\(Error)", title: "")
                }
            )

            isHiddenInRoom = true
        }
        
        //self.isHidden
//viewGrey
        
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
}