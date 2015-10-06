//
//  CancelAddSiteViewController.swift
//  MolePeopleBrowser
//
//  Created by Timmy Nguyen on 10/5/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class CancelAddSiteViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    deinit {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClick(sender: AnyObject) {
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
        self.dismissViewControllerAnimated(true, completion: nil)
        //if let navController = self.navigationController {
        //    navController.popViewControllerAnimated(true)
        //}
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
