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
    //NOTE: Realm can’t store computed properties
    var coordinate:CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
    
    //Use this func to indicate the primary key to Realm. A primary key works like a unique identifier. Each object in the Realm database must have a different value for the primary key, just like each house in a village must have a unique and distinct address. Realm uses the primary key to distinguish objects from one another, and determines whether an object is unique or not.
    override static func primaryKey() -> String? {
        return "id";
    }
    
}