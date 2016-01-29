//
//  NSBundle+Version.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 1/28/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

extension NSBundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}