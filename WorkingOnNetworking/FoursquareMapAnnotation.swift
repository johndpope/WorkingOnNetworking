//
//  FoursquareMapAnnotation.swift
//  WorkingOnNetworking
//
//  Created by Donovan Cotter on 1/20/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import Foundation
import MapKit


//creating a new class called CoffeeAnnotation that inherits from NSObject and implements the MKAnnotation protocol. That last part is important: before you can use a class as an annotation, it needs to conform to the annotation protocol.

//These properties are required to be part of the class, because the protocol dictates so.

class FoursquareMapAnnotation: NSObject, MKAnnotation {
    let title:String?
    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}