//
//  String+ToDouble.swift
//  Sift
//
//  Created by Timmy Nguyen on 12/9/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    

    func removeHtml() ->String?{
        let str = self.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        return str
    }

}