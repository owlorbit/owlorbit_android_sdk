//
//  String+Trim.swift
//  Owl Orbit
//
//  Created by Timmy Nguyen on 10/15/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}