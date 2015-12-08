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


class ProfileImageUploadViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCropViewTapProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgCropView: ImageCropView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.emptyDataSetSource = self
        //self.tableView.emptyDataSetDelegate = self

        //self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
        
        var switchContextBtn : UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Plain, target: self, action: "btnContinueClick:")
        self.navigationItem.rightBarButtonItem = switchContextBtn
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.title = "Profile Image"

        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        //  tap.delegate = self
        self.view.addGestureRecognizer(tap)
        selectImage()
    }
    
    func handleTap(){
        selectImage()
    }
    
    func btnContinueClick(sender:AnyObject){
        
        
        let spinner = ALThreeCircleSpinner(frame: CGRectMake(0,0,44,44))
        spinner.center = self.view.center;
        spinner.startAnimating()
        self.view.addSubview(spinner)

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            UserApiHelper.uploadProfileImage(self.imgCropView.croppedImage()!, resultJSON: {
                (JSON) in
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
            })
            
        }
    }
    
    func onImageCropViewTapped(imageCropView: ImageCropView) {
        print("wtfff")
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
        
        let controller = ImagePickerSheetController(mediaType: .Image)
        controller.maximumSelection = 1;
        controller.addAction(ImagePickerAction(title: NSLocalizedString("Take Photo Or Video", comment: "Action Title"), secondaryTitle: NSLocalizedString("Select Image", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { _, numberOfPhotos in
                print("Comment \(numberOfPhotos) photos")
                print("Send \(controller.selectedImageAssets)")
                
                if(controller.selectedImageAssets.count > 0){
                    
                    
                    self.imgCropView.setup(ImageHelper.getAssetThumbnail(controller.selectedImageAssets[0], widthHeight: 320.0), tapDelegate: self)
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
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
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
