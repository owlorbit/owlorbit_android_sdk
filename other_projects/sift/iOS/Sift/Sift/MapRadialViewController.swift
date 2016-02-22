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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            FullScreenLoaderHelper.removeLoader()
                            
                            navController.popViewControllerAnimated(true)
                            
                            if(self.delegate != nil){
                                self.delegate.didExitRoom(self)
                            }
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
        
        
        
        //let address = "1 Infinite Loop, CA, USA"
        let address:String! = txtSearch.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                //remove all previous find addresses?
                
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
                
                
                self.mapView.addAnnotation(customFindAddressPin)
                print("hey there \(coordinates)")
            }
        })
        
        
        self.txtSearch.text = ""
        return true
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