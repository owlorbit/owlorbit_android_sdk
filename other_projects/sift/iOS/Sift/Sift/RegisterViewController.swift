//
//  RegisterViewController.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/12/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToHome")
        tap.numberOfTapsRequired = 1;
        btnBack.userInteractionEnabled = true;
        btnBack.addGestureRecognizer(tap)
        

        self.navigationController?.setNavigationBarHidden(true, animated: false);
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func btnNextTouchUp(sender: AnyObject) {
        var viewController : RegisterBasicInfoViewController = RegisterBasicInfoViewController();
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    func backToHome(){
        self.navigationController?.popToRootViewControllerAnimated(true);
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
