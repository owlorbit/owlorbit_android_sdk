//
//  SettingsViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/11/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage.Swift
import DGElasticPullToRefresh

class SettingsViewController: UIViewController, ProfileSettingsDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data:NSMutableArray = [];
    let downloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = ProjectConstants.AppColors.PRIMARY
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.title = "Settings"
        self.tableView.registerNib(UINib(nibName: "UserProfileSearchTableViewCell", bundle:nil), forCellReuseIdentifier: "UserProfileSearchTableViewCell")

        self.tableView.registerNib(UINib(nibName: "UserLogoutTableViewCell", bundle:nil), forCellReuseIdentifier: "UserLogoutTableViewCell")

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        data.addObject(user)
        data.addObject("LOGOUT")
        initTableViewSettings()
    }
    
    func initTableViewSettings(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = ProjectConstants.AppColors.PRIMARY
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(ProjectConstants.AppColors.PRIMARY)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    deinit {
        if(tableView != nil){
            tableView.dg_removePullToRefresh()
        }
    }
    
    public func updateProfile(){
        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        var profileImageUrl:String = ProjectConstants.ApiBaseUrl.value + user.avatarOriginal
        var URLRequest = NSMutableURLRequest(URL: NSURL(string: profileImageUrl)!)
        URLRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        downloader.downloadImage(URLRequest: URLRequest) { response in
            if let image = response.result.value {
                print("image download...")
                ApplicationManager.userData.profileImage = image
                self.tableView.reloadData()
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let str = data[indexPath.row] as? String {
            return UserLogoutTableViewCell.cellHeight()
        }else{
            return UserProfileSearchTableViewCell.cellHeight()
        }
        
        return ReadMessageTableViewCell.cellHeight();
    }

    @IBAction func btnPowerDown(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.locationManager.stopUpdatingLocation()
        appDelegate.locationManager.stopMonitoringSignificantLocationChanges()
        
        let vc = DisableGPSViewController(nibName: "DisableGPSViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.navigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        if let str = data[indexPath.row] as? String {
            
            print("cover: \(indexPath.row)")
            var cell:UserLogoutTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserLogoutTableViewCell")! as! UserLogoutTableViewCell
            
            return cell!
        }else{
            var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
            var cell:UserProfileSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("UserProfileSearchTableViewCell")! as! UserProfileSearchTableViewCell
            cell?.imgAvatar.image = ApplicationManager.userData.profileImage
            cell?.txtName.text = user.firstName + " " + user.lastName
            
            cell?.imgAvatar.layer.masksToBounds = true
            cell!.imgAvatar.layer.cornerRadius = cell!.imgAvatar.frame.size.height/2
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //get all user ids..?
        
        if let str = data[indexPath.row] as? String {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setupLoggedOutViewController()
            //navigationController?.popToRootViewControllerAnimated(true)
        }else{
        
            let vc = ProfileSettingImageUploadViewController(nibName: "ProfileSettingImageUploadViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self;
            navigationController?.pushViewController(vc, animated: true )
        }

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
