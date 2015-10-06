//
//  ViewSiteViewController.swift
//  MolePeopleBrowser
//
//  Created by Timmy Nguyen on 9/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import CoreData

class ViewSiteViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var masterParentPage:ParentPageModel!
    let coreDataHelper:CoreDataHelper = MoleManager.shareCoreDataInstance;
    var subLinks = -1;
    var commentDoneLoading = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.delegate = self;
        test(NSDate(), baseUrl:"https://news.ycombinator.com")
    }
    
    func downloadComments(  parentPage: ParentPageModel , commentIds:NSDictionary){

        var commentPagesArr:NSMutableSet = NSMutableSet()

        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {
            for (key, value) in commentIds {
                
                while(!self.commentDoneLoading){
                    print("comment load barrel..")
                    sleep(1)
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
                })

                self.commentDoneLoading = false
            }
        })
        
        
        
        
        parentPage.commentPages = commentPagesArr;
        //then save
        masterParentPage = parentPage
        ParentPageHelper.insert(parentPage)
    
    }
    
    
    func loadCommentPage(commentPage : CommentPageModel){
        self.webView.loadHTMLString(commentPage.html, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))
    }

    func test(createdDate : NSDate, baseUrl : String){
        
        SiteDownloaderHelper.test{
            (responseStr) in
            //var newString = responseStr?.stringByReplacingOccurrencesOfString("Hacker News", withString: "Hack")
            //newString = newString!.stringByReplacingOccurrencesOfString("href=\"item", withString: "/href=\"https://news.ycombinator.com/item")
            if(responseStr == nil){
                print ("response nil.")
                return;
            }
            self.webView.loadHTMLString(responseStr!, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))
            print("base url: \(NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))")

            var commentPagesId = SiteScraperHelper.parseHackerNewsComments(responseStr!)
            let entity = NSEntityDescription.entityForName("ParentPageModel", inManagedObjectContext: self.coreDataHelper.managedObjectContext)
            var parentPage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext) as! ParentPageModel

            parentPage.url = ProjectConstants.ParentBaseUrls.HackerNews
            parentPage.html = responseStr!
            parentPage.created = createdDate;

            self.downloadComments(parentPage, commentIds: commentPagesId)
            ParentPageHelper.insert(parentPage)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        //print("Webview started Loading: \(webView.request?.URL)")
    }

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType:UIWebViewNavigationType) -> Bool {

        if(subLinks >= 0){
        
            let urlPathArr = request.URL?.absoluteString.characters.split {$0 == "/"}.map { String($0) }
            var urlPath = masterParentPage.url + "/"  + (urlPathArr?[urlPathArr!.count-1])!
            //let entity = NSEntityDescription.entityForName("CommentPageModel", inManagedObjectContext: self.coreDataHelper.managedObjectContext)
            //var commentPage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext) as! CommentPageModel

            var commentPage = CommentPageModel.getCommentPage(urlPath,  managedObjectContext:self.coreDataHelper.managedObjectContext, createdDate:masterParentPage.created) as! CommentPageModel
            print("color blind")
            print(commentPage.html)
            
            subLinks = -2;
            loadCommentPage(commentPage)
        }
        
        //let entity = NSEntityDescription.entityForName("CommentPageModel", inManagedObjectContext: self.coreDataHelper.managedObjectContext)
        //var commentPage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext) as! CommentPageModel
        //var comment : CommentPageModel = NSEntityDescription.insertNewObjectForEntityForName("CommentPageModel", inManagedObjectContext: coreDataHelper.managedObjectContext) as! CommentPageModel

        //commentPage = commentPage.getCommentPage(urlPath, createdDate:masterParentPage.created)
        //print(commentPage.html)

        //print ((CommentPageModel.getCommentPage(urlPath, created:masterParentPage.created) as CommentPageModel).html)
        //now search coredata for that comment...
        
        subLinks++;
        return true;
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
