//
//  Venue.swift
//  WorkingOnNetworking
//
//  Created by Donovan Cotter on 1/20/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Venue: Object {
    dynamic var id:String = ""
    dynamic var name:String = ""
    
    dynamic var latitude:Float = 0
    dynamic var longitude:Float = 0
    
    dynamic var address:String = ""
    var coordinate:CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
}