//
//  WriteMessageViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/23/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class WriteMessageViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewSearchContainer.layer.cornerRadius = 4
        self.viewSearchContainer.layer.masksToBounds = true

        self.txtSearch.borderStyle = UITextBorderStyle.None
        self.txtSearch.attributedPlaceholder = NSAttributedString(string:self.txtSearch.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.txtSearch.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func txtSearchOnChange(sender: AnyObject) {
        //print(self.txtSearch.text);
        
        UserApiHelper.findUser(self.txtSearch.text!, resultJSON:{
            (JSON) in
            print("woohoo")
            print(JSON)
        });
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "0 friends")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "This app is useless without contacts...")
    }

    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool{
        return true
    }

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool{
        return true
    }

    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint{
        return CGPointMake(0, 400.0);
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
