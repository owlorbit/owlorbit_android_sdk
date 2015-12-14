//
//  FullScreenLoaderHelper.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 12/10/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation
import ALThreeCircleSpinner

class FullScreenLoaderHelper: NSObject {

    class func startLoader(){
        ApplicationManager.spinner = ALThreeCircleSpinner(frame: CGRectMake(0,0,44,44))

        ApplicationManager.spinnerBg  = UIView(frame: ((UIApplication.sharedApplication().delegate?.window)!)!.frame)
        ApplicationManager.spinnerBg.backgroundColor = UIColor( colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        ((UIApplication.sharedApplication().delegate?.window)!)!.addSubview(ApplicationManager.spinnerBg)
        UIView.animateWithDuration(0.5) {
            ApplicationManager.spinnerBg.backgroundColor = UIColor( colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.78)
        }

        ApplicationManager.spinner.center = ((UIApplication.sharedApplication().delegate?.window)!)!.center;
        ApplicationManager.spinner.startAnimating()
        ((UIApplication.sharedApplication().delegate?.window)!)!.addSubview(ApplicationManager.spinner)
    }
    
    class func removeLoader(){
        ApplicationManager.spinner.stopAnimating()
        
        
        ApplicationManager.spinner.removeFromSuperview()
        ApplicationManager.spinnerBg.removeFromSuperview()
    }

}