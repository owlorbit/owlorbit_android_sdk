//
//  ViewController.swift
//  MolePeopleBrowser
//
//  Created by Timmy Nguyen on 9/19/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var data :NSMutableArray = ["aa", "bb"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerNib(UINib(nibName: "SavedSnapshotTableViewCell", bundle:nil), forCellReuseIdentifier: "SavedSnapshotTableViewCell")
        //print(NSDate().formattedAsTimeAgo())
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SavedSnapshotTableViewCell") as! SavedSnapshotTableViewCell
        
        cell.populate()
        //cell.textLabel?.text = self.data[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print( "derp")
        self.performSegueWithIdentifier("loadSiteSegue", sender:nil)
    }
    
}

