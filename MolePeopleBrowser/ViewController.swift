//
//  ViewController.swift
//  MolePeopleBrowser
//
//  Created by Timmy Nguyen on 9/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var commentDoneLoading = true;
    let coreDataHelper:CoreDataHelper = MoleManager.shareCoreDataInstance;
    var data:[ParentPageModel] = [];
    var selectedIndex = 0;
    var isDoneDownloadingComments = false;
    var commentCounter = 0
    var commentCount = 0
    var loadingNotification:MBProgressHUD = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerNib(UINib(nibName: "SavedSnapshotTableViewCell", bundle:nil), forCellReuseIdentifier: "SavedSnapshotTableViewCell")
        //print(NSDate().formattedAsTimeAgo())
        data = ParentPageModel.getAllParentPages(coreDataHelper.managedObjectContext)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.5;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    @IBAction func btnStartWebCrawlClick(sender: AnyObject) {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.AnnularDeterminate

        loadingNotification.labelText = "Loading"
        self.downloadUrl(NSDate(), baseUrl:"https://news.ycombinator.com")
    }
    

    func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SavedSnapshotTableViewCell") as! SavedSnapshotTableViewCell

        cell.populate(data[indexPath.row])
        //cell.textLabel?.text = self.data[indexPath.row] as? String
        return cell
    }
    
    
    
    func downloadComments(  parentPage: ParentPageModel , commentIds:NSDictionary){
        
        var commentPagesArr:NSMutableSet = NSMutableSet()
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        commentCount = commentIds.count
        commentCounter = 0
        
        dispatch_async(backgroundQueue, {
            for (key, value) in commentIds {
                
                while(!self.commentDoneLoading){
                    
                }
                sleep(1)
                var linkId = key as! String
                var commentUrl = (ProjectConstants.ParentBaseUrls.HackerNews + "/" + ProjectConstants.CommentBaseUrls.HackerNews + linkId) as! String
                var comment : CommentPageModel = NSEntityDescription.insertNewObjectForEntityForName("CommentPageModel",inManagedObjectContext: self.coreDataHelper.managedObjectContext) as! CommentPageModel
                comment.url = commentUrl
                comment.created = parentPage.created
                commentPagesArr.addObject(comment)
                
                SiteDownloaderHelper.getSiteHtml(commentUrl, completionHandler:{
                    (responseStr) in

                    comment.html = responseStr!
                    ParentPageHelper.insert(parentPage)
                    self.commentDoneLoading = true
                    self.loadingNotification.progress = Float(self.commentCounter) / Float(commentIds.count)
                    
                    if(self.commentCounter == (commentIds.count - 1)){
                        self.hideLoadingHUD()
                    }
                    self.commentCounter++
                })

                self.commentDoneLoading = false
            }
        })
        
        //then save
        parentPage.commentPages = commentPagesArr;
        ParentPageHelper.insert(parentPage)
    }

    func downloadUrl(createdDate : NSDate, baseUrl : String){
        
        SiteDownloaderHelper.test{
            (responseStr) in
            
            if(responseStr == nil){
                print ("response nil.")
                return;
            }
            print("base url: \(NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))")
            
            var commentPagesId = SiteScraperHelper.parseHackerNewsComments(responseStr!)
            let entity = NSEntityDescription.entityForName("ParentPageModel", inManagedObjectContext: self.coreDataHelper.managedObjectContext)
            var parentPage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext) as! ParentPageModel
            
            parentPage.url = ProjectConstants.ParentBaseUrls.HackerNews
            parentPage.html = responseStr!
            parentPage.created = createdDate;
            
            self.downloadComments(parentPage, commentIds: commentPagesId)
            ParentPageHelper.insert(parentPage)
            
            self.data = ParentPageModel.getAllParentPages(self.coreDataHelper.managedObjectContext)!
            self.tableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadSiteSegue" {
            var vc = segue.destinationViewController as! ViewSiteViewController
            vc.masterParentPage = data[selectedIndex]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //so lazy tim...
        selectedIndex = indexPath.row
        self.performSegueWithIdentifier("loadSiteSegue", sender:nil)
    }
    
}

