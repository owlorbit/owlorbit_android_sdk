//
//  ProfileImageUploadViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/2/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import Photos
import DZNEmptyDataSet
import ALThreeCircleSpinner
import ImageCropView
import ImagePickerSheetController


protocol ProfileDelegate {
    func updateProfile()
}

class ProfileImageUploadViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCropViewTapProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgCropView: ImageCropView!
    var controller:ImagePickerSheetController = ImagePickerSheetController(mediaType: .Image)
    
    var delegate:ProfileDelegate?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var selectImgButton : UIBarButtonItem = UIBarButtonItem(title: "Pick", style: UIBarButtonItemStyle.Plain, target: self, action: "btnSelectImg")
        self.navigationItem.leftBarButtonItem = selectImgButton

        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Plain, target: self, action: "btnContinueClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.title = "Profile Image"

        initLoadImagePicker()
        selectImage()
    }
    
    func buttonMethod() {
    }
    
    func btnSelectImg(){
        selectImage()
    }
    
    func initLoadImagePicker(){
        
    }
    
    func btnContinueClick(sender:AnyObject){

        FullScreenLoaderHelper.startLoader()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {

            UserApiHelper.uploadProfileImage(self.imgCropView.croppedImage()!, resultJSON: {
                (JSON) in

                FullScreenLoaderHelper.removeLoader();
                if let navController = self.navigationController {
                    
                    //self.initProfile();
                    //self.imgCropView.croppedImage()
                    
                    var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
                    UserApiHelper.loginUser(user.email, password: user.password, resultJSON: {
                        (JSON) in
                        
                        FullScreenLoaderHelper.removeLoader();
                        var hasFailed:Bool = (JSON["hasFailed"]) ? true : false
                        if(!hasFailed){                            
                            PersonalUserModel.updateUserFromLogin(user.email, password: user.password, serverReturnedData: JSON)
                            
                            ApplicationManager.userData.profileImage = self.imgCropView.croppedImage()
                            navController.popViewControllerAnimated(true)
                        }
                        }, error:{
                            (errorMsg) in
                            FullScreenLoaderHelper.removeLoader();
                            AlertHelper.createPopupMessage("\(errorMsg)", title:  "Error")
                    });
                }
            })
            
        }
    }
    
    func onImageCropViewTapped(imageCropView: ImageCropView) {
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage =  ImageHelper.RBSquareImageTo(image, size: CGSizeMake(620,620) )
        self.imgCropView.setup(selectedImage, tapDelegate: self)
        self.imgCropView.display()
        self.imgCropView.editable = true
        self.navigationItem.rightBarButtonItem?.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func selectImage(){

        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }

        controller = ImagePickerSheetController(mediaType: .Image)
        controller.maximumSelection = 1;
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Take a Selfie", comment: "Action Title"), secondaryTitle: NSLocalizedString("Select Image", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            
            print("this was picked..")
            
            }, secondaryHandler: { _, numberOfPhotos in
                print("Comment \(numberOfPhotos) photos")
                print("Send \(self.controller.selectedImageAssets)")
                
                if(self.controller.selectedImageAssets.count > 0){
                    self.imgCropView.setup(ImageHelper.getAssetThumbnail(self.controller.selectedImageAssets[0], widthHeight: 620.0), tapDelegate: self)
                    self.imgCropView.display()
                    self.imgCropView.editable = true
                    self.navigationItem.rightBarButtonItem?.enabled = true
                }
        }))
        
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: NSLocalizedString("Cancel", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.PhotoLibrary)
                print("photo picker..")
            }, secondaryHandler: { _, numberOfPhotos in
                self.navigationItem.rightBarButtonItem?.enabled = false
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            controller.modalPresentationStyle = .Popover
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize())
        }

        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //how do i hide this fucker...
        controller.dismissViewControllerAnimated(false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Upload a Profile Image")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Take a Picture or Choose an Image!")
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool{
        return true
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool{
        return true
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
