//
//  MapRadialViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/18/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import Foundation
import QuartzCore


class MapRadialViewController: ChatThreadViewController{
    
    var displayMenu:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initMapLongPress()
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
        print("deactive user room...")
        AlertHelper.createPopupMessage("Leave Room to be implemented...", title: "")
    }
    
    @IBAction override func createDropActionClick(sender: AnyObject) {

        UIView.animateWithDuration(0.5, animations: {() -> Void in
            var infoFrame: CGRect = self.addMeetupView!.frame
            infoFrame.origin.y = 0.0
            self.addMeetupView!.frame = infoFrame
        })
    }

    func initMapLongPress(){
        var uilgr = UILongPressGestureRecognizer(target: self, action: "longPressMap:")
        uilgr.minimumPressDuration = 2.0
        self.mapView.addGestureRecognizer (uilgr)
    }
   
    
    
    override func longPressMap(gestureRecognizer:UIGestureRecognizer){
        super.longPressMap(gestureRecognizer)
        print("FAUCK")
        //mapView.showAnnotations(self.mapView.selectedAnnotations, animated: true)
        
        
        
        for (var i:Int = 0; i < self.mapView.annotations.count;i++){
            var val = self.mapView.annotations[i] as! MKAnnotation
        
            var annotationView:UIView  = self.mapView.viewForAnnotation(val)!
            if ( CGRectContainsPoint(annotationView.bounds, gestureRecognizer.locationInView(annotationView)) ){
                // we can continue
                print("long press working..")
            }
        }
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