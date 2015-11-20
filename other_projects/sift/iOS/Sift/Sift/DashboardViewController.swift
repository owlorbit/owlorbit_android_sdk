//
//  DashboardViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("fucking a")

        //let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        //navigationController?.pushViewController(vc, animated: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTest(sender: AnyObject) {
        
        print("why no push..?")
        
        let vc = ChatThreadViewController(nibName: "ChatThreadViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true )

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
