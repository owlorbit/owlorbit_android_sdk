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
    var currentUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.delegate = self;
        self.webView.scalesPageToFit = true;
        
        if(masterParentPage != nil){
            currentUrl = masterParentPage.url
            self.webView.loadHTMLString(masterParentPage.html, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))
        }
    }

    func loadCommentPage(commentPage : CommentPageModel){
        self.webView.loadHTMLString(commentPage.html, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        //print("Webview started Loading: \(webView.request?.URL)")
    }

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType:UIWebViewNavigationType) -> Bool {

        if(subLinks >= 0){
        
            let urlPathArr = request.URL?.absoluteString.characters.split {$0 == "/"}.map { String($0) }
            var urlPath = masterParentPage.url + "/"  + (urlPathArr?[urlPathArr!.count-1])!
            var commentPage = CommentPageModel.getCommentPage(urlPath,  managedObjectContext:self.coreDataHelper.managedObjectContext, createdDate:masterParentPage.created) as! CommentPageModel
            subLinks = -2;
            currentUrl = commentPage.url
            loadCommentPage(commentPage)
            
            //Display back-button
            
            
        }

        subLinks++;
        return true;
    }

    @IBAction func btnBackClick(sender: AnyObject) {
        
        if(currentUrl == masterParentPage.url){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            subLinks = -1;
            currentUrl = masterParentPage.url
            self.webView.loadHTMLString(masterParentPage.html, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!))
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
