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



class ChatThreadViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    //will be removed / cleaned up/////
    let spanX:Double = 0.00725;
    let spanY:Double = 0.00725;
    var locationManager:CLLocationManager = CLLocationManager();
    var annotations:NSMutableArray = NSMutableArray();

    //person

    var profileImage:UIImage = UIImage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if(self.title.cou != ""){
            self.title = "Tim's Chat Room"
        //}

        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        // Do any additional setup after loading the view.

        locationManager.requestWhenInUseAuthorization();
        locationManager.requestAlwaysAuthorization();
        mapView.showsUserLocation = true;
        locationManager.delegate = self;

        mapView.zoomEnabled = true;

        profileImage = UIImage(named:"test")!.resizedImageToFitInSize(CGSizeMake(45, 45), scaleIfSmaller: true)
        profileImage = profileImage.roundImage()
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
        print("latitude: \(userLocation.location?.coordinate.latitude) \nlongitude:  \(userLocation.location?.coordinate.longitude)")

        //TODO 
        //send API based off logged in ID
    }

    func zoomToCurrentLocation() {

        do{
            
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
                }
                else {
                    anView!.annotation = annotation
                }


                anView!.image = profileImage
                
                //profileImage
                //anView!.image = CGRectIntegral(anView!.image.frame);

                //pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                //pinView!.image = UIImage(named:"test.jpg")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

                return anView
            }
            
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = .Purple
            }
            else {
                pinView!.annotation = annotation
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
