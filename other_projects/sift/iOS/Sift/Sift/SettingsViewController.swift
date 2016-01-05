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

class SettingsViewController: UIViewController, ProfileSettingsDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data:NSMutableArray = [];
    let downloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.tableView.registerNib(UINib(nibName: "ReadMessageTableViewCell", bundle:nil), forCellReuseIdentifier: "ReadMessageTableViewCell")
        //self.navigationController!.navigationBar.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)
        
        self.tableView.registerNib(UINib(nibName: "UserProfileSearchTableViewCell", bundle:nil), forCellReuseIdentifier: "UserProfileSearchTableViewCell")

        self.tableView.registerNib(UINib(nibName: "UserLogoutTableViewCell", bundle:nil), forCellReuseIdentifier: "UserLogoutTableViewCell")

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        data.addObject(user)
        data.addObject("LOGOUT")
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
        return ReadMessageTableViewCell.cellHeight();
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
