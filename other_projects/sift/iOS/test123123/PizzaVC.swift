//
//  PizzaVC.swift
//  test123123
//
//  Created by Timmy Nguyen on 11/11/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class PizzaVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn(sender: AnyObject) {
        print("iojwefo")
        
        let vc = PieVC(nibName: "PieVC", bundle: nil)
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
