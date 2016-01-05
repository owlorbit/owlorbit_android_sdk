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

class ChatThreadViewController: UIViewController, CLLocationManagerDelegate, ChatSubmitDelegate, MKMapViewDelegate {

    @IBOutlet weak var bottomConstraintTextField: NSLayoutConstraint!
    @IBOutlet weak var chatKeyboardView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var txtChatView: AUIAutoGrowingTextView!

    var chatRoomTitle:String = "";
    var roomId:String = ""
    let downloader = ImageDownloader()
    var profileImg:UIImage = UIImage()

    //will be removed / cleaned up/////
    let spanX:Double = 0.00725;
    let spanY:Double = 0.00725;
    var locationManager:CLLocationManager = CLLocationManager();
    var annotations:NSMutableArray = NSMutableArray();
    
    var messageRecentlySent:Bool = false;
    var profileImage:UIImage = UIImage()
    
    var locationDict = [String:UserPointAnnotation]()
    var timerGetLocations = NSTimer()
    
    
    var RETRIEVE_LOCATION_LOCK:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = self.chatRoomTitle
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "btnTextClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        //Do any additional setup after loading the view.

        locationManager.requestWhenInUseAuthorization();
        locationManager.requestAlwaysAuthorization();
        mapView.showsUserLocation = true;
        locationManager.delegate = self;
        mapView.zoomEnabled = true;
        self.chatContainerView.hidden = true;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        var chatMapKeyboard:ChatMapKeyboardView = NSBundle.mainBundle().loadNibNamed("ChatMapKeyboardView", owner: self, options:nil)[0] as! ChatMapKeyboardView

        chatMapKeyboard.delegate = self
        self.mapView.delegate = self;
        self.txtChatView.inputAccessoryView = chatMapKeyboard
        
        self.txtChatView.placeholder = "Enter text..."
        self.txtChatView.placeholderColor = UIColor.lightGrayColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        if ApplicationManager.userData.profileImage != nil{
            self.profileImg = ApplicationManager.userData.profileImage!
            self.profileImage = self.profileImg.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
            self.profileImage = self.profileImage.roundImage()
        }

        loadProfileImg()
        initLocations()
    }

    func loadProfileImg(){

        //GenericUserModel
        var roomData:RoomManagedModel = RoomManagedModel.getById(roomId)!;

        for obj in roomData.attributes.users {
            var userData:GenericUserManagedModel = obj as! GenericUserManagedModel

            if(userData.avatarOriginal != ""){
                var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + userData.avatarOriginal
                var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
                URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                downloader.downloadImage(URLRequest: URLRequest) { response in
                    if let image = response.result.value {
                        userData.avatarImg = image
                        userData.avatarImg = userData.avatarImg.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
                        userData.avatarImg = userData.avatarImg.roundImage()
                        self.addUser(userData)
                    }
                }
            }
        }
    }

    func initLocations(){
        timerGetLocations = NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: "timerCallLocations", userInfo: nil, repeats: true)
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
        //print("Process locations.. \(json)")

        for (key,subJson):(String, SwiftyJSON.JSON) in json["user_locations"] {
            var location:LocationModel = LocationModel(json: subJson);
            
            //self.annotations.addObject(userPoint)
            
            var userPointAnnotation:UserPointAnnotation = getAnnotationByUserId(location.userId)
            userPointAnnotation.coordinate = location.coordinate!
            
            //now update...
        }

        self.RETRIEVE_LOCATION_LOCK = false
    }

    //make device id eventually...
    func getAnnotationByUserId(userId:String)->UserPointAnnotation{

        for val in self.annotations{
            var userPointAnnotation:UserPointAnnotation = val as! UserPointAnnotation
            if(userPointAnnotation.userModel.userId == userId){
                return userPointAnnotation
            }
        }
        return UserPointAnnotation();
    }
    
    func addUser(userModel:GenericUserManagedModel){
        
        //make sure userModel doesn't exist in annotations list...
        var userPoint:UserPointAnnotation = UserPointAnnotation()
        userPoint.userModel = userModel
        userPoint.coordinate = CLLocationCoordinate2D(latitude: 40, longitude: -72)

        self.annotations.addObject(userPoint)
        self.mapView.addAnnotation(userPoint)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func submitChat() {
        ChatApiHelper.sendMessage(self.txtChatView.text, roomId: roomId, resultJSON: {
            (JSON) in            
            self.txtChatView.text = ""
            print(JSON)
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraintTextField.constant = 0
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraintTextField.constant = keyboardFrame.size.height
        })
    }
    
    func btnTextClick(sender: AnyObject){
        //var userPoint:UserPointAnnotation = self.annotations[0] as! UserPointAnnotation
        //userPoint.coordinate = CLLocationCoordinate2D(latitude: 50, longitude: -52)
        //self.annotations.addObject(userPoint)

        
        /*var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "btnMapClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        print("btn text click..")
        self.mapView.hidden = true;
        self.chatContainerView.hidden = false;*/
        
        var viewController:ChatTextMessageViewController = ChatTextMessageViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    func btnMapClick(sender: AnyObject){
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "btnTextClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        self.mapView.hidden = false;
        self.chatContainerView.hidden = true;
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
            break
        case .AuthorizedWhenInUse:
                locationManager.startUpdatingLocation()
                zoomToCurrentLocation()
            break
        case .AuthorizedAlways:
                locationManager.startUpdatingLocation()
                zoomToCurrentLocation()
            break
        case .Restricted:
        break

        case .Denied:
            break
        default:
        break
        }
    }

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        
        var latitude:String = (userLocation.location?.coordinate.latitude.description)!
        var longitude:String = (userLocation.location?.coordinate.longitude.description)!
        

        //TODO 
        //send location
        //but dont spam..

        /*
        //if sent within the past 5 seconds, don't send
        //
        */
        
        if(!messageRecentlySent){
            print("latitude: \(latitude) \nlongitude:  \(longitude)")
            messageRecentlySent = true
            
            LocationApiHelper.sendLocation(longitude, latitude: latitude, resultJSON:{
                (JSON) in
                print(JSON)
                var messageRecentTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "updateMessageTimer:", userInfo: nil, repeats: false)
            });
        }
    }
    
    func updateMessageTimer(timer: NSTimer) {
    
        messageRecentlySent = false
        timer.invalidate()
    }

    func zoomToCurrentLocation() {

        do{
            if(locationManager.location == nil){return}
            //if not connected reject..
            var region:MKCoordinateRegion = MKCoordinateRegion();
            region.center.latitude = locationManager.location!.coordinate.latitude;
            region.center.longitude = locationManager.location!.coordinate.longitude;
            region.span.latitudeDelta = spanX;
            region.span.longitudeDelta = spanY;
            mapView.setRegion(region, animated: true)

        }catch _ {
            
        }
    }
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            


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

                //anView!.image = profileImage
                
                if(ApplicationManager.userData.profileImage != nil){
                    anView!.image = profileImage
                }else{
                    anView!.image = UIImage(named:"owl_orbit")?.resizedImageToFitInSize(CGSize(width: 40, height: 40), scaleIfSmaller: true)
                }
                
                return anView
            }

            let reuseId = "pinAvatarImg"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            let userPointAnnotation:UserPointAnnotation = annotation as! UserPointAnnotation;
            //sprint(".....\(userPointAnnotation.pinCustomImageName)")
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.image = userPointAnnotation.userModel.avatarImg
            } else {
                pinView!.annotation = annotation
                //pinView!.image = userPointAnnotation.userModel.avatarImg

                /*if(userPointAnnotation.userModel.avatarImg != nil){
                    pinView!.image = profileImage
                }else{
                    pinView!.image = UIImage(named:"owl_orbit")
                }*/
                //pinView!.image = UIImage(named:"owl_orbit")
            }
            
            return pinView
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
        self.timerGetLocations.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
