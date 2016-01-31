//
//  UserProfileViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/26/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

import ZSWRoundedImage
import SwiftyJSON
import Alamofire
import AlamofireImage.Swift

class UserProfileViewController: UIViewController {
    
    var targetAnnotation:UserPointAnnotation = UserPointAnnotation();
    let downloader = ImageDownloader()
    @IBOutlet weak var userProfile: UIImageView!
    
    @IBOutlet weak var profileContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = targetAnnotation.userModel.firstName + " Profile"

        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + targetAnnotation.userModel.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        //userProfile.image = targetAnnotation.userModel.originalAvatar.roundImage()
        userProfile.image = targetAnnotation.userModel.originalAvatar
        
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Right
        profileContainer.addGestureRecognizer(swipeDown)

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped down")
                self.navigationController?.navigationBarHidden = false
                self.navigationController!.popViewControllerAnimated(true)
            default:
                break
            }
        }
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
