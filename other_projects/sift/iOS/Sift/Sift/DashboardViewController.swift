//
//  DashboardViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var data:NSMutableArray = [];
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        //navigationController?.pushViewController(vc, animated: true )
        data.addObject("a")
        var createNewBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "createNewBtnClick:")
        
        createNewBtn.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)
        self.navigationItem.rightBarButtonItem = createNewBtn
        
        self.tableView.registerNib(UINib(nibName: "ReadMessageTableViewCell", bundle:nil), forCellReuseIdentifier: "ReadMessageTableViewCell")
    }
    
    func createNewBtnClick(sender: AnyObject){
        //WriteMessageViewController

        let vc = WriteMessageViewController(nibName: "WriteMessageViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController!.navigationBar.tintColor = UIColor(red:255.0/255.0, green:193.0/255.0, blue:73.0/255.0, alpha:1.0)
        navigationController?.pushViewController(vc, animated: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTest(sender: AnyObject) {
        
        //print("why no push..?")
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true )

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReadMessageTableViewCell.cellHeight();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:ReadMessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ReadMessageTableViewCell")! as! ReadMessageTableViewCell


        cell?.populate()
        //cell.populate(data[indexPath.row])
        //cell.textLabel?.text = self.data[indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedIndex = indexPath.row
        //self.performSegueWithIdentifier("loadSiteSegue", sender:nil)
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true )
        
        
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
