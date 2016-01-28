//
//  ChatMapInstructionsViewController.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/25/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

import UIKit

class ChatMapInstructionsViewController: UIViewController {

    var routeSteps = [MKRouteStep]()
    var userAnnotation:UserPointAnnotation = UserPointAnnotation();
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Directions to " + userAnnotation.userModel.firstName.capitalizedString
        // Do any additional setup after loading the view.
        
        self.tableView.registerNib(UINib(nibName: "MapInstructionsTableViewCell", bundle:nil), forCellReuseIdentifier: "MapInstructionsTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MapInstructionsTableViewCell.cellHeight();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MapInstructionsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("MapInstructionsTableViewCell")! as! MapInstructionsTableViewCell
        var mkRouteStep:MKRouteStep = routeSteps[indexPath.row] as MKRouteStep
        
        if(indexPath.row == 0){
            cell?.populateFirstCell(mkRouteStep)
        }else{
            cell?.populate(mkRouteStep)
        }

        return cell!
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
