//
//  UILabel+ItalicBold.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/23/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 14)
    }
    
    func italic() -> UIFont {
        return withTraits(.TraitItalic)
    }
    
    func bold() -> UIFont {
        return withTraits(.TraitBold)
    }
    
    func normal() -> UIFont {
        return withTraits()
    }
    
}
