//
//  ChatThreadViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import QuartzCore
import ZSWRoundedImage
import SwiftyJSON
import Alamofire
import AlamofireImage.Swift
import UITextView_Placeholder
import SwiftDate
import BusyNavigationBar

import LNRSimpleNotifications
import AudioToolbox

class ChatThreadViewController: UIViewController, CLLocationManagerDelegate, ChatSubmitDelegate, MKMapViewDelegate, UITextViewDelegate, AddMeetupDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var bottomConstraintTextField: NSLayoutConstraint!
    @IBOutlet weak var chatKeyboardView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtChatView: AUIAutoGrowingTextView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnMeetup: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    var chatRoomTitle:String = "";
    var roomId:String = ""
    let downloader = ImageDownloader()
    var profileImg:UIImage = UIImage()

    //will be removed / cleaned up/////
    let spanX:Double = 0.00725;
    let spanY:Double = 0.00725;

    var annotations:NSMutableArray = NSMutableArray();
    var messageRecentlySent:Bool = false;
    var profileImage:UIImage = UIImage()
    
    var locationDict = [String:UserPointAnnotation]()
    var timerGetLocations:NSTimer?
    var RETRIEVE_LOCATION_LOCK:Bool = false
    var destination: MKMapItem?


    var targetAnnotation:UserPointAnnotation = UserPointAnnotation();
    var routeSteps = [MKRouteStep]()
    
    
    var prevUserCount:Int = 0
    
    var progressOptions = BusyNavigationBarOptions()
    let notificationManager = LNRNotificationManager()
    
    @IBOutlet weak var btnInstructions: UIButton!
    var chatMapKeyboard:ChatMapKeyboardView?
    
    var addMeetupView:AddMeetupView?
    var isYourUserLoaded:Bool = false;
    var tapGesture:UILongPressGestureRecognizer?;
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.chatRoomTitle
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "btnTextClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        //Do any additional setup after loading the view.
   
        mapView.showsUserLocation = true;
        mapView.zoomEnabled = true;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        chatMapKeyboard = NSBundle.mainBundle().loadNibNamed("ChatMapKeyboardView", owner: self, options:nil)[0] as! ChatMapKeyboardView

        chatMapKeyboard!.delegate = self
        self.mapView.delegate = self;
        self.txtChatView.inputAccessoryView = chatMapKeyboard
        chatMapKeyboard!.btnSend.enabled = false;
        chatMapKeyboard!.btnSend.alpha = 0;
        
        self.txtChatView.placeholder = "Enter text..."
        self.txtChatView.placeholderColor = UIColor.lightGrayColor()
        self.txtChatView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        if ApplicationManager.userData.profileImage != nil{
            self.profileImg = ApplicationManager.userData.profileImage!
            self.profileImage = self.profileImg.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
            self.profileImage = self.profileImage.roundImage()
        }

        initAddMeetup()
        addMapViewOnClick()
        loadProfileImg()
        initLocations()
        initLoadingBar()
        
        initMapNotifications()
        //hideInstructions()

        zoomToCurrentLocation()
        enableMapViewTracking()
    }
    
    func addMapViewOnClick(){
        //self.mapView
    }
    
    func enableMapViewTracking(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.locationManager.stopUpdatingLocation()
        appDelegate.locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func disableMapViewTracking(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.locationManager.stopUpdatingLocation()
        appDelegate.locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func hideInstructions(){
        btnInstructions.hidden = true;
        
        UIView.animateWithDuration(0.5) {
            self.btnInstructions.alpha = 0;
            self.view.layoutIfNeeded()
        }
    }
    
    func showInstructions(){
        btnInstructions.hidden = false;

        UIView.animateWithDuration(0.5) {
            self.btnInstructions.alpha = 1;
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if(textView.text == ""){
            self.chatMapKeyboard!.btnSend.enabled = false;
            UIView.animateWithDuration(0.1) {
                self.chatMapKeyboard!.btnSend.alpha = 0;
                self.view.layoutIfNeeded()
            }
        }else{
            self.chatMapKeyboard!.btnSend.enabled = true;
            UIView.animateWithDuration(0.1) {
                
                self.chatMapKeyboard!.btnSend.alpha = 1;
                self.view.layoutIfNeeded()
            }
        }
    }

    
    func initMapNotifications(){
        
        notificationManager.notificationsPosition = LNRNotificationPosition.Top
        notificationManager.notificationsBackgroundColor = UIColor.whiteColor()
        notificationManager.notificationsTitleTextColor = UIColor.blackColor()
        notificationManager.notificationsBodyTextColor = UIColor.darkGrayColor()
        notificationManager.notificationsSeperatorColor = UIColor.grayColor()
        notificationManager.notificationsIcon = self.profileImage
            
            //UIImage(named:"owl_orbit")?.resizedImageToFitInSize(CGSize(width: 40, height: 40), scaleIfSmaller: true)
        
        var alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
            notificationManager.notificationSound = mySound
        }
    }
    
    func methodThatTriggersNotification(title: String, body: String) {
        
        notificationManager.showNotification(title, body: body, callback: { () -> Void in
            self.notificationManager.dismissActiveNotification({ () -> Void in
                var viewController:ChatTextMessageViewController = ChatTextMessageViewController();
                viewController.roomId = self.roomId;
                self.navigationController!.pushViewController(viewController, animated: true)
                
            })
        })
    }
    
    @IBAction func btnInstructionClick(sender: AnyObject) {

        let vc = ChatMapInstructionsViewController(nibName: "ChatMapInstructionsViewController", bundle: nil)
        
        vc.userAnnotation = self.targetAnnotation
        vc.routeSteps = routeSteps
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true )
    }
    
    func initLoadingBar(){
        
        /**
        Animation type
        
        - Stripes: Sliding stripes as seen in Periscope app.
        - Bars: Bars going up and down like a wave.
        - CustomLayer(() -> CALayer): Your layer to be inserted in navigation bar. In this case, properties other than `transparentMaskEnabled` and `alpha` will not be used.
        */
        progressOptions.animationType = .Stripes
        
        /// Color of the shapes. Defaults to gray.
        progressOptions.color = ProjectConstants.AppColors.ORANGE
        
        /// Alpha of the animation layer. Remember that there is also an additional (constant) gradient mask over the animation layer. Defaults to 0.5.
        progressOptions.alpha = 1.0
        
        /// Width of the bar. Defaults to 20.
        progressOptions.barWidth = 20
        
        /// Gap between bars. Defaults to 30.
        progressOptions.gapWidth = 30
        
        /// Speed of the animation. 1 corresponds to 0.5 sec. Defaults to 1.
        progressOptions.speed = 1
        
        /// Flag for enabling the transparent masking layer over the animation layer.
        progressOptions.transparentMaskEnabled = true
        
        
        // Start animation
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        showInstructions()
        
        self.navigationController?.navigationBar.stop()
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var text:String = self.txtChatView.text

        //routes = response.routes[0].ste
        self.mapView.removeOverlays(self.mapView.overlays)
        for route in response.routes as! [MKRoute] {
            self.mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            routeSteps = route.steps
        }

        let userLocation:MKUserLocation = self.mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)
    }
    
    
    @IBAction func btnDriveClick(sender: AnyObject) {

        hideInstructions()
        destination = MKMapItem()
        
        var latitude: Double = targetAnnotation.coordinate.latitude
        var longitude: Double = targetAnnotation.coordinate.longitude
        var placemark: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude), addressDictionary: nil)
        destination = MKMapItem(placemark: placemark)
        destination?.name = "Tims Dungeon"
        
        self.navigationController?.navigationBar.start(progressOptions)
        getDirections()
    }
    
    func navigateMeetup(customMeetupPin:CustomMeetupPin){
        
        
        hideInstructions()
        var meetupAnnotation = UserPointAnnotation()
        meetupAnnotation.coordinate = customMeetupPin.coordinate
        self.targetAnnotation = meetupAnnotation
        
        destination = MKMapItem()
        var placemark: MKPlacemark = MKPlacemark(coordinate: customMeetupPin.coordinate, addressDictionary: nil)
        destination = MKMapItem(placemark: placemark)
        destination?.name = customMeetupPin.title
        
        self.navigationController?.navigationBar.start(progressOptions)
        getDirections()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor(red:131.0/255.0, green:134.0/255.0, blue:169.0/255.0, alpha:1.0)
            renderer.lineWidth = 5.0
            return renderer
    }
    //MKDirectionsTransportType.Walking

    func getWalkingDirections() {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.transportType = MKDirectionsTransportType.Walking
        request.destination = destination!
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler{
            response, error in
            
            guard let response = response else {
                //handle the error here
                return
            }
            self.showRoute(response)
        }
    }
    
    func initAddMeetup(){
        var mainWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        self.addMeetupView = AddMeetupView.initView()
        self.addMeetupView!.frame = UIScreen.mainScreen().bounds
        self.addMeetupView!.delegate = self
        UIScreen.mainScreen().bounds.height
        var infoFrame: CGRect = self.addMeetupView!.frame
        infoFrame.origin.y = UIScreen.mainScreen().bounds.height * 2
        self.addMeetupView!.frame = infoFrame
        mainWindow.addSubview(self.addMeetupView!)
    }
    
    func addMeetup(title:String, subtitle:String, global:Bool){

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if(appDelegate.locationManager.location == nil){return}

        self.addMeetupView?.txtTitle.text = ""

        hideMeetUp()

        LocationApiHelper.createMeetup(title, subtitle: subtitle, isGlobal: global, roomId: self.roomId, longitude: String(self.mapView.centerCoordinate.longitude), latitude: String(self.mapView.centerCoordinate.latitude), resultJSON: {
            (JSON) in
                var meetupId:String! = JSON["meetup_id"].int?.stringValue
                var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
                let annotation = CustomMeetupPin()
                
                annotation.coordinate = self.mapView.centerCoordinate // your location here
                annotation.title = title
                annotation.id = meetupId
                annotation.userId = user.userId
                annotation.subtitle = subtitle
            
                self.annotations.addObject(annotation)
                self.mapView.addAnnotation(annotation)

                print("meetup \(meetupId)")
            }, error: {
                (String) in
                print("error \(String)")
        })
        
    }
    
    func cancelMeetup(){
        hideMeetUp()
        self.addMeetupView?.txtTitle.text = ""
    }
    
    func hideMeetUp(){
        var mainWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            var infoFrame: CGRect = self.addMeetupView!.frame
            infoFrame.origin.y = UIScreen.mainScreen().bounds.height * 2
            self.addMeetupView!.frame = infoFrame
        })
    }

    @IBAction func createDropActionClick(sender: AnyObject) {
    }

    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination!
        request.requestsAlternateRoutes = false
        //request.transportType = MKDirectionsTransportType.Automobile
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler{
            response, error in

            guard let response = response else {
                //handle the error here
                return
            }
            self.showRoute(response)
        }
    }

    func loadProfileImg(){

        //GenericUserModel
        var roomData:RoomManagedModel? = RoomManagedModel.getById(roomId);

        if(roomData == nil){
            return;
        }

        for obj in roomData!.attributes.users {
            var userData:GenericUserManagedModel = obj as! GenericUserManagedModel

            if(userData.avatarOriginal != ""){
                var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + userData.avatarOriginal
                var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
                //URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                print ("start loading.. \(profileImageUrl)")
                downloader.downloadImage(URLRequest: URLRequest) { response in
                    if let image = response.result.value {
                        userData.originalAvatar = image
                        userData.avatarImg = image
                        userData.avatarImg = userData.avatarImg.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
                        userData.avatarImg = userData.avatarImg.roundImage()
                        self.addUser(userData)
                        print ("user has been added")
                    }
                }
            }
        }
    }

    func initLocations(){
        timerCallLocations()
        timerGetLocations = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "timerCallLocations", userInfo: nil, repeats: true)
    }
    
    func timerCallLocations(){
        
        if(RETRIEVE_LOCATION_LOCK){return;}

        RETRIEVE_LOCATION_LOCK = true
        LocationApiHelper.getRoomLocations(self.roomId,resultJSON:{
        (JSON) in
            self.updateLocations(JSON)
        });
    }
    
    func updateLocations(json:JSON){

        do {
            var currentUserCount = 0
            for (key,subJson):(String, SwiftyJSON.JSON) in json["user_locations"] {
                var location:LocationModel = LocationModel(json: subJson);

                var userPointAnnotation:UserPointAnnotation? = getAnnotationByUserId(location.userId)
                if(userPointAnnotation != nil){
                    userPointAnnotation!.coordinate = location.coordinate!
                    userPointAnnotation!.userModel.longitude = location.coordinate!.longitude
                    userPointAnnotation!.userModel.latitude = location.coordinate!.latitude
                    userPointAnnotation!.title = userPointAnnotation!.userModel.firstName.capitalizedString

                    if(location.created != nil){
                        userPointAnnotation!.userModel.lastPositionTimestamp = location.created
                    }

                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    var dateString = dateFormatter.stringFromDate(location.created!)
                    var timeAgo = NSDate.mysqlDatetimeFormattedAsTimeAgoFull(dateString)
                    userPointAnnotation!.subtitle = "Last active \(timeAgo)"

                    //save context
                    ApplicationManager.shareCoreDataInstance.saveContext()
                }else{
                    //fix this..
                    /*
                    if let userModelExtreme = userPointAnnotation!.userModel{
                        if(userModelExtreme.latitude != 0 && userModelExtreme.longitude != 0){
                            var storedLocation = CLLocationCoordinate2D.init(latitude: userModelExtreme.latitude, longitude: userModelExtreme.longitude)
                            userPointAnnotation!.coordinate = storedLocation
                        }
                    }*/
                }
                
                //if(userPointAnnotation!.userModel != nil){
                //    userPointAnnotation!.title = userPointAnnotation!.userModel.firstName.capitalizedString
                //}
                currentUserCount++;
            }
            
            for (key,subJson):(String, SwiftyJSON.JSON) in json["meetup_locations"] {
                
                var meetupId:String! = subJson["id"].string
                var userId:String! = subJson["user_id"].string
                var longitude:Double! = Double(subJson["longitude"].string!)
                var latitude:Double! = Double(subJson["latitude"].string!)

                var meetupTitle:String! = subJson["title"].string!
                var meetupSubtitle:String! = subJson["subtitle"].string!
                
                if let userMeetupAnnotation:CustomMeetupPin = getMeetupAnnotation(meetupId){
                    userMeetupAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                    userMeetupAnnotation.title = meetupTitle
                    userMeetupAnnotation.subtitle = meetupSubtitle
                }else{
                    let annotation = CustomMeetupPin()
                    annotation.id = meetupId
                    annotation.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                    annotation.title = meetupTitle
                    annotation.subtitle = meetupSubtitle
                    annotation.userId = userId

                    self.annotations.addObject(annotation)
                    self.mapView.addAnnotation(annotation)
                }
            }
            
            removeOldMeetupAnnotations(json["meetup_locations"])
            
            if(prevUserCount != currentUserCount && currentUserCount > 0 && isYourUserLoaded){
                prevUserCount = currentUserCount
                mapView.showAnnotations(mapView.annotations, animated: true)
            }
        } catch _{
            print("error catch")
        }

        self.RETRIEVE_LOCATION_LOCK = false
    }
    
    func getMeetupAnnotation(annotationId:String)->CustomMeetupPin?{

        for val in self.annotations{
            if val is CustomMeetupPin{
                var meetupPointAnnotation:CustomMeetupPin = val as! CustomMeetupPin
                if(meetupPointAnnotation.id == annotationId){
                    return meetupPointAnnotation
                }
            }
 
        }
        return nil;
    }
    
    func removeMeetupAnnotation(annotationId:String)->Void{
        
        for (var i:Int = 0; i < self.mapView.annotations.count;i++){
            var val = self.mapView.annotations[i]
            //for val in self.annotations{
            if val is CustomMeetupPin{
                var meetupPointAnnotation:CustomMeetupPin = val as! CustomMeetupPin
                if(meetupPointAnnotation.id == annotationId){
                    ///return meetupPointAnnotation
                    self.annotations.removeObject(val)
                    self.mapView.removeAnnotation( val )
                    return;
                }
            }
        }
    }
    
    func removeOldMeetupAnnotations(meetupJSON:SwiftyJSON.JSON)->Void{

        for (var i:Int = self.mapView.annotations.count-1; i >= 0; i--){
            var containsAnnotation:Bool = false
            var val = self.mapView.annotations[i]

            if val is CustomMeetupPin{
                for (key,subJson):(String, SwiftyJSON.JSON) in meetupJSON {
                    var meetupId:String! = subJson["id"].string
                    if(meetupId == (val as! CustomMeetupPin).id){
                        containsAnnotation = true
                    }
                }
                
                if(!containsAnnotation){
                    self.annotations.removeObject(val)
                    self.mapView.removeAnnotation( val )
                }
            }
        }
        
    }

    //make device id eventually...
    func getAnnotationByUserId(userId:String)->UserPointAnnotation?{

        for val in self.annotations{
            
            if val is UserPointAnnotation{
                var userPointAnnotation:UserPointAnnotation = val as! UserPointAnnotation
                if(userPointAnnotation.userModel.userId == userId){
                    return userPointAnnotation
                }
            }
        }
        return nil;
    }
    
    func addUser(userModel:GenericUserManagedModel){

        if(!MapHelper.doesUserExist(self.annotations, userModel:userModel)){
        
            var userPoint:UserPointAnnotation = UserPointAnnotation()
            userPoint.userModel = userModel

            if(userModel.latitude != 0 && userModel.longitude != 0){
                var storedLocation = CLLocationCoordinate2D.init(latitude: userModel.latitude, longitude: userModel.longitude)
                userPoint.coordinate = storedLocation
            }

            self.annotations.addObject(userPoint)
            self.mapView.addAnnotation(userPoint)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func submitChat() {
        
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var text:String = self.txtChatView.text
        
        if(text == ""){
            return;
        }

        chatMapKeyboard!.btnSend.enabled = false;
        var date:NSDate = NSDate()
        var messageCore : MessageModel = MessageModel(messageId: "", senderId: user.userId, senderDisplayName: user.firstName, isMediaMessage: false, date: date.inUTCRegion().UTCDate, roomId: roomId , text: text)
        MessageCoreModel.insertFromMessageModel(messageCore)
        
        var updatedDate:DateInRegion = DateInRegion(UTCDate: date.inUTCRegion().UTCDate, region: Region(tzType: TimeZoneNames.America.New_York))!
        var createdDate:String = updatedDate.toString(DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))! //prints out 10:12
        
        //use this as an outline... for all updating tokens
        
        methodThatTriggersNotification("You Say:", body: text)
        ChatApiHelper.sendMessage(text, roomId:roomId, created:createdDate, resultJSON: {
            (JSON) in
                self.txtChatView.text = ""
            }, error:{
                (message, errorCode) in
                
                if(errorCode < 0){
                    UserApiHelper.updateToken({
                        self.txtChatView.text = ""
                        //things are updated... so now call the send message again..
                        ChatApiHelper.sendMessage(text, roomId:self.roomId, created:createdDate, resultJSON: {_ in }, error:{_ in})
                        }, error: {
                            (errorMsg) in
                            AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                    })
                }
        })
        
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraintTextField.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    func keyboardWillShow(notification: NSNotification) {

        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraintTextField.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        })
    }
    
    func btnTextClick(sender: AnyObject){
        var viewController:ChatTextMessageViewController = ChatTextMessageViewController();
        viewController.roomId = roomId;
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    func btnMapClick(sender: AnyObject){
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "btnTextClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        self.mapView.hidden = false;
    }
    
    /*
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        var latitude:String = (userLocation.location?.coordinate.latitude.description)!
        var longitude:String = (userLocation.location?.coordinate.longitude.description)!

        if(!messageRecentlySent){
            messageRecentlySent = true
            
            print("tim: \(longitude) - \(latitude)")
            LocationApiHelper.sendLocation(longitude, latitude: latitude, resultJSON:{
                (JSON) in
                print(JSON)
                var messageRecentTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "updateMessageTimer:", userInfo: nil, repeats: false)
                }, error:{
                    (String) in
                    self.messageRecentlySent = false
                }
            );
        }
    }
    
    func updateMessageTimer(timer: NSTimer) {
    
        NSLog("map view App is still sending...")
        messageRecentlySent = false
        timer.invalidate()
    }
*/
    func zoomToCurrentLocation() {

        do{
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

            if(appDelegate.locationManager.location == nil){return}
            //if not connected reject..
            var region:MKCoordinateRegion = MKCoordinateRegion();
            region.center.latitude = appDelegate.locationManager.location!.coordinate.latitude;
            region.center.longitude = appDelegate.locationManager.location!.coordinate.longitude;
            region.span.latitudeDelta = spanX;
            region.span.longitudeDelta = spanY;
            mapView.setRegion(region, animated: true)

        }catch _ {
            
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
            case .Starting:
                //view.dragState = .Dragging

                break
            case .Canceling:
                break
            case .Ending:
                //view.dragState = .None
                
                if view.annotation is CustomMeetupPin{
                    var meetupAnnotation:CustomMeetupPin = view.annotation as! CustomMeetupPin
                    var meetupId:String! = meetupAnnotation.id

                    LocationApiHelper.updateMeetup(meetupId, longitude: String(meetupAnnotation.coordinate.longitude), latitude: String(meetupAnnotation.coordinate.latitude), resultJSON: {
                    (JSON) in
                        print("success update")
                    }, error: {
                    (String) in
                        print("error \(String)")
                    })
                }

                break
            default: break
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

            tapGesture = UILongPressGestureRecognizer(target: self, action: "tapGestureClick:")
            //tapGesture!.numberOfTapsRequired = 2;
            tapGesture!.delegate = self;

            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                //return nil
                let reuseId = "test"
                var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
                
                if anView == nil {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                } else {
                    anView!.annotation = annotation
                }
                
                anView!.canShowCallout = true

                //anView!.image = profileImage
                if(ApplicationManager.userData.profileImage != nil){
                    anView!.image = profileImage
                }else{
                    anView!.image = UIImage(named:"owl_orbit")?.resizedImageToFitInSize(CGSize(width: 40, height: 40), scaleIfSmaller: true)
                }

                isYourUserLoaded = true;
                anView?.addGestureRecognizer(tapGesture!)

                return anView
            }
        
            if annotation is CustomMeetupPin{

                let meetupPin:CustomMeetupPin = annotation as! CustomMeetupPin;
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "meetupPin")
                pinAnnotationView.pinColor = .Purple
                
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.animatesDrop = true
                
                let leftButton : MeetupButton = MeetupButton(type: UIButtonType.Custom) as! MeetupButton
                //leftButton.frame = CGRectMake(0, 0, 44, 44)
                leftButton.frame.size.width = 44
                leftButton.frame.size.height = 51
                leftButton.backgroundColor = ProjectConstants.AppColors.PRIMARY
                leftButton.setImage(UIImage(named: "white_car_icon"), forState: UIControlState.Normal)
                leftButton.meetupPin = meetupPin
                leftButton.addTarget(self, action: "navigateMeetupClick:", forControlEvents: UIControlEvents.TouchUpInside)
                pinAnnotationView.leftCalloutAccessoryView = leftButton
                
                var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
                if(meetupPin.userId == user.userId){
                    pinAnnotationView.draggable = true
                    let button : MeetupButton = MeetupButton(type: UIButtonType.ContactAdd) as! MeetupButton
                    button.setImage(UIImage(named: "delete_icon"), forState: UIControlState.Normal)
                    button.frame = CGRectMake(10, 0, 25, 25)
                    button.meetupPin = meetupPin
                    button.addTarget(self, action: "deleteAnnotation:", forControlEvents: UIControlEvents.TouchUpInside)
                    pinAnnotationView.rightCalloutAccessoryView = button
                }else{
                    print("opposing: \(meetupPin.userId) -- \(user.userId)")
                }

                
                pinAnnotationView.addGestureRecognizer(tapGesture!)

                return pinAnnotationView
            }
            
            //these are non-you annotations..
            let reuseId = "pinAvatarImg"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            let userPointAnnotation:UserPointAnnotation = annotation as! UserPointAnnotation;

            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.image = userPointAnnotation.userModel.avatarImg
                //pinView!.image = UIImage(named:"owl_orbit")?.resizedImageToFitInSize(CGSize(width: 40, height: 40), scaleIfSmaller: true);
            } else {
                pinView!.annotation = annotation
            }
        
            if(!CLLocationCoordinate2DIsValid(userPointAnnotation.coordinate)){
                return nil;
            }

            pinView!.canShowCallout = true


            let button : AnnotationButton = AnnotationButton(type: UIButtonType.ContactAdd) as! AnnotationButton
            button.setImage(UIImage(named: "right_arrow_map"), forState: UIControlState.Normal)
            button.frame = CGRectMake(10, 0, 25, 25)
            button.userPointAnnotation = userPointAnnotation
            button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            pinView!.rightCalloutAccessoryView = button

            let leftButton : AnnotationButton = AnnotationButton(type: UIButtonType.Custom) as! AnnotationButton
            //leftButton.frame = CGRectMake(0, 0, 44, 44)
            leftButton.frame.size.width = 44
            leftButton.frame.size.height = 51
            leftButton.backgroundColor = ProjectConstants.AppColors.PRIMARY
            leftButton.setImage(UIImage(named: "white_car_icon"), forState: UIControlState.Normal)
            leftButton.userPointAnnotation = userPointAnnotation
            leftButton.addTarget(self, action: "leftButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            pinView!.leftCalloutAccessoryView = leftButton
            pinView!.addGestureRecognizer(tapGesture!)
        
            return pinView
    }
    
    
    
    var prevSelected:MKAnnotationView?;
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        prevSelected = view
        //self.mapView.deselectAnnotation(view.annotation, animated: false)
        
        /*
        var region:MKCoordinateRegion = MKCoordinateRegion();
        region.center.latitude = view.annotation!.coordinate.latitude;
        region.center.longitude = view.annotation!.coordinate.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        mapView.setRegion(region, animated: true)
        */
        
        /*
        if view.annotation is CustomMeetupPin{
            
            
            
        }else if view.annotation is UserPointAnnotation{
            
            
            
        }*/
    }
    
    
    func tapGestureClick(gestureRecognizer:UIGestureRecognizer){
        

        var region:MKCoordinateRegion = MKCoordinateRegion();
        if(prevSelected == nil){
            var view: UIView = gestureRecognizer.view!
            var loc: CGPoint = gestureRecognizer.locationInView(view)
            var subview  = view.hitTest(loc, withEvent: nil) as! MKAnnotationView
            
            region.center.latitude = subview.annotation!.coordinate.latitude;
            region.center.longitude = subview.annotation!.coordinate.longitude;
            
            region.span.latitudeDelta = spanX;
            region.span.longitudeDelta = spanY;
            mapView.setRegion(region, animated: true)
            self.mapView.selectAnnotation(subview.annotation!, animated: false)
        }else{
            region.center.latitude = prevSelected!.annotation!.coordinate.latitude;
            region.center.longitude = prevSelected!.annotation!.coordinate.longitude;
            
            region.span.latitudeDelta = spanX;
            region.span.longitudeDelta = spanY;
            mapView.setRegion(region, animated: true)
            
            self.mapView.selectAnnotation(prevSelected!.annotation!, animated: false)
        }
        
        
        
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func longPressMap(gestureRecognizer:UIGestureRecognizer){
        print("derp")
    }
    
    
    func navigateMeetupClick (sender : MeetupButton!) {
        navigateMeetup(sender.meetupPin)
    }
    
    
    func deleteAnnotation (sender : MeetupButton!) {
        //navigateMeetup(sender.meetupPin)
        print("remove..\(sender.meetupPin.id)")
        
        
        LocationApiHelper.disableMeetup(sender.meetupPin.id, resultJSON: {
            (JSON) in
            
                //remove annotations..
                self.removeMeetupAnnotation(sender.meetupPin.id)

            }, error: {
                (String) in
                print("error \(String)")
        })
    }
    
    //leftButtonClicked
    func leftButtonClicked (sender : AnnotationButton!) {
        self.targetAnnotation = sender.userPointAnnotation
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        
        self.btnDriveClick(sender)
    }
    
    func buttonClicked (sender : AnnotationButton!) {
        
        
        /*
        topTargetUserMenu.constant = 64
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        */

        self.targetAnnotation = sender.userPointAnnotation
        
        var viewController:UserProfileViewController = UserProfileViewController();
        viewController.targetAnnotation = self.targetAnnotation
        
        viewController.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBarHidden = true
        self.navigationController!.pushViewController(viewController, animated: true)
        
        //launch profile..
        //print("buggy. \(sender.userPointAnnotation.coordinate.latitude)")
    }

    func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        let imageRef = image.CGImage
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        //alias..
        typealias fucking = CGInterpolationQuality
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, fucking.High)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        
        CGContextConcatCTM(context, flipVertical)
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef)
        
        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
        let newImage = UIImage(CGImage: newImageRef)
        
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        var imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer

        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)

        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timerGetLocations?.invalidate()
        timerGetLocations = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timerGetLocations?.invalidate()
        timerGetLocations = nil
    }
    
    
    @IBAction func btnMenuClick(sender: AnyObject) {
    }
    
    @IBAction func btnExitClick(sender: AnyObject) {
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
