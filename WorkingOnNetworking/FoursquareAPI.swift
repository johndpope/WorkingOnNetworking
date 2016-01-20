//
//  FoursquareAPI.swift
//  WorkingOnNetworking
//
//  Created by Donovan Cotter on 1/20/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import Foundation
import QuadratTouch
import MapKit
import RealmSwift

struct API {
    struct notifications {
        static let venuesUpdated = "venues updated"
    }
}

class FourSquareAPI {
    //This “shared instance” is only accessible through the class CoffeeAPI, and is instantiated when the app starts (eager loading).
    static let sharedInstance = FourSquareAPI()
    //Declare a class property called session, of type Session? (from Das Quadrat).
    var session: Session?
    
    init() {
        //initialize the Foursquare Client
        let client = Client(clientID: "CFITOPDZUHBDVUIVCHOC5XUCVZ5OVHE40RIIUZA2AZXLSMUZ", clientSecret: "E4EG5TBFZDLGUSJDEOGMFRNAQCDU03W3JQDBD0T31G5HH35J", redirectURL: "")
        let configuration = Configuration(client: client)
        Session.setupSharedSessionWithConfiguration(configuration)
        
        self.session = Session.sharedSession()
        
    }
    
    
    
    func getBreweriesWithLocation(location: CLLocation) {
        
        //Setup, configuration and start of the API request.
        if let session = self.session {
            
            //method parameters is called on location. Location is provided as a parameter in the method getBreweriesWithLocation. Every time the method is called you have to give it a location argument too. Also, parameters is in the extension for CLLocation.
            var parameters = location.parameters()
            parameters += [Parameter.categoryId: "50327c8591d4c4b30a586d5d"]
            parameters += [Parameter.radius: "2000"]
            parameters += [Parameter.limit: "50"]
            
            // Start a "search", i.e. an async call to Foursquare that should return venue data
            //Call venues on session, and search on venues. The method search takes two (not one!) arguments: the parameters you created, and also the closure that’s below it. This way of writing is known as a trailing closure. The closure is the last parameter of the method, so instead of writing it within the method call parentheses, you can write it outside and wrap it inside squiggly brackets. The method search returns a reference to the lengthy task. It doesn’t start automatically, we start it later (near the end of the method).
            let searchTask = session.venues.search(parameters)
                {
                    //Completion handler of the request
                    //The closure is executed when the search task completes! Check that the app will jump from the let searchTask … code line to the searchTask.start() line, and will jump to the if let response = … line when the data from the HTTP API is returned to the app.
                    //The closures signature (called closure expression syntax) is this: (result) -> Void in. It means that within the closure a parameter result is available, and that the closure returns nothing (Void).
                    (result) -> Void in
                    if let response = result.response {
                        //“Untangling” of the request result data, and the start of the Realm transaction.
                        //response[“venues”] is not nil and if it can be cast (“converted”) to type [[String: AnyObject]].
                        if let venues = response["venues"] as? [[String: AnyObject]] {
                            autoreleasepool {
                                //instantiate a Realm with line let realm = try! Realm()
                                let realm = try! Realm()
                                realm.beginWrite()
                                
                                //The for-in loop that loops over all the venue data.
                                for venue:[String: AnyObject] in venues {
                                    let venueObject:Venue = Venue()
                                    
                                    if let id = venue["id"] as? String {
                                        venueObject.id = id
                                    }
                                    
                                    if let name = venue["name"] as? String {
                                        venueObject.name = name
                                    }
                                    
                                    if let location = venue["location"] as? [String: AnyObject] {
                                        
                                        if let longitude = location["lng"] as? Float {
                                            venueObject.longitude = longitude
                                        }
                                        
                                        if let latitude = location["lat"] as? Float {
                                            venueObject.latitude = latitude
                                        }
                                        if let formattedAddress = location["formattedAddress"] as? [String] {
                                        }
                                        
                                    }
                                    //add the venueObject to Realm, and write it to the database
                                    //"update" argument indicates that when this object already exists, Realm should overwrite it with the new data
                                    realm.add(venueObject, update: true)
                                }
                                //
                                do {
                                    try realm.commitWrite()
                                    print("Committing Write")
                                    
                                }
                                catch (let error) {
                                    print("DID NOT WRITE TO REALM \(error)")
                                }
                                
                            }
                            //The end of the completion handler, it sends a notification.
                            NSNotificationCenter.defaultCenter().postNotificationName(API.notifications.venuesUpdated, object: nil, userInfo: nil)
                        }
                        
                    }
            }
            
            searchTask.start()
            
        }
    }
}

//Every time a CLLocation instance is used in your code, and this extension is loaded, you can call the method parameters on the instance, even when it’s not part of the original MapKit code.
extension CLLocation {
    
    //The parameter method returns an instance of Parameters, which is in turn a simple key-value dictionary that contains parameterized information (GPS location and accuracy).
    func parameters() -> Parameters {
        let latLong = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let latLongAccuracy = "\(self.horizontalAccuracy)"
        let altitude = "\(self.altitude)"
        let altitudeAccuracy = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:latLong,
            Parameter.llAcc:latLongAccuracy,
            Parameter.alt:altitude,
            Parameter.altAcc:altitudeAccuracy
        ]
        
        return parameters
        
    }
    
    
    
    
    
}
