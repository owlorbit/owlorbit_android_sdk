//
//  UIImage+Round.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/17/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

extension UIImage
{
    func roundImage() -> UIImage
    {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2

        UIGraphicsBeginImageContextWithOptions(self.size, false , 0.0)
        let bounds = CGRect(origin: CGPointZero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.drawInRect(bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}