//
//  CustomMapPin.swift
//  Sift
//
//  Created by Timmy Nguyen on 11/17/15.
//  Copyright © 2015 Tim Nuwin. All rights reserved.
//
import MapKit

class CustomMapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}