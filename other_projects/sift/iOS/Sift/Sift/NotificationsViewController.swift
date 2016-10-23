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
import SwiftyJSON
import AlamofireImage.Swift
import DGElasticPullToRefresh

class NotificationsViewController: UIViewController {

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
        
        self.title = "Notifications"
        self.tableView.registerNib(UINib(nibName: "NotificationTableViewCell", bundle:nil), forCellReuseIdentifier: "NotificationTableViewCell")

        var user:PersonalUserModel = PersonalUserModel.get()[0] as PersonalUserModel;
        //initTableViewSettings()
        
        loadNotifications()
        
    }
    
    func loadNotifications(){
        //NotificationApiHelper
        
        
        NotificationApiHelper.getCode({
            (JSON) in
            
                self.data.removeAllObjects()
                for (key,subJson):(String, SwiftyJSON.JSON) in JSON["notification"] {
                    var notification:NotificationModel = NotificationModel(json:subJson)
                    self.data.addObject(notification)
                }
                self.tableView.reloadData()
                self.tableView.es_stopPullToRefresh(completion: true)
            }, error:{
            (String, errorCode) in
                print("error \(String)")
        })
    }
    
    func initTableViewSettings(){
        
        /*
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = ProjectConstants.AppColors.PRIMARY
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(ProjectConstants.AppColors.PRIMARY)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)*/
        
        tableView.es_addPullToRefresh(handler:{
            [weak self] in
            // refresh code
            self!.loadNotifications()
        })
        
    }
    
    deinit {
        if(tableView != nil){
            tableView.dg_removePullToRefresh()
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
        return NotificationTableViewCell.cellHeight();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:NotificationTableViewCell? = tableView.dequeueReusableCellWithIdentifier("NotificationTableViewCell")! as! NotificationTableViewCell
        var notification:NotificationModel = self.data[indexPath.row] as! NotificationModel
        cell?.populate(notification)

        //cell?.imgAvatar.layer.masksToBounds = true
        //cell!.imgAvatar.layer.cornerRadius = cell!.imgAvatar.frame.size.height/2
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //get all user ids..?        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
