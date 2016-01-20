//
//  ViewController.swift
//  WorkingOnNetworking
//
//  Created by GLR on 1/19/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class FourSquareTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    let distanceSpan: Double = 500
    var lastLocation:CLLocation?
    var venues:Results<(Venue)>?

    override func viewDidLoad() {
        super.viewDidLoad()

        //This will tell the notification center that self (the current class) is listening to a notification of type API.notifications.venuesUpdated. Whenever that notification is posted the method onVenuesUpdated: of ViewController is invoked. Clever, right?
         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onVenuesUpdated:"), name: API.notifications.venuesUpdated, object: nil)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let mapView = self.mapView
        {
            mapView.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            //This method will cause a popup in the app asking for permission to use the GPS location data.
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            //This will cause the location manager to poll for a GPS location, and call a method on the delegate telling it the new GPS location.
            locationManager!.startUpdatingLocation()
            
        }
    }
    
    //the method has 3 parameters: the location manager that called the method, the new GPS location, and the old GPS location.
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            //a region is calculated from the new GPS coordinate and the distanceSpan (500 x 500) we created earlier with the newLocation coordinate in the center.
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
            
            //calls refreshVenues with the GPS location of the user. Additionally, it tells the API to request data from Foursquare. Essentially, every time the user moves new data is requested from Foursquare. Thanks to the settings that only happens once every 50 meters. And thanks to the notification center, the map is updated!
            refreshVenues(newLocation, getDataFromFoursquare: true)
            
        }
    }
    
    //The refreshVenues method could be called when no location data is available, i.e. from a place in your code that is disconnected from the location data method. We want to call refreshVenues independently from method locationManager:didUpdateToLocation:fromLocation we need to store the location data separate from that method.
    
    //Every time the refreshVenues method is called we store the location parameter in the lastLocation property if the location parameter isn’t nil. Then, we check with optional binding that lastLocation isn’t nil. The if-statement executes only when it contains a value, so we can be 100% certain that the code block inside the if-statement always contains a valid GPS location!
    
    //getDataFromFoursquare parameter is false by default, so no data from Foursquare is requested. You get it: this would in turn trigger an infinite loop in which the return of data causes a request for data ad infinitum. It changes to true in locationManager(). So it essentially requests new data from Foursquare when the user changes location. Which we set to change only every 50 meters in viewDidAppear.
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare:Bool = false) {
        
        if location != nil {
            lastLocation = location
        }
        
        if let location = lastLocation {
            if getDataFromFoursquare == true {
                FourSquareAPI.sharedInstance.getBreweriesWithLocation(location)
            }
            
            //First, a reference to Realm is made. Then, all the objects of class Venue are requested from Realm and stored in the venues property. This property is of type Results?, which is essentially an array of Venue instances (with a little extra stuff).
            let realm = try! Realm()
            venues = realm.objects(Venue)
            
            // for-in loop that iterates over all the venues and adds it as an annotation to the map view
            for venue in venues! {
                let annotation = FoursquareMapAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                
                mapView?.addAnnotation(annotation)
            }
        }
    }
    
    func onVenuesUpdated(notification:NSNotification) {
        refreshVenues(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Just like a table view, a map view utilizes reusable instances to smoothly display pins on the map
    //Note that this method is part of the delegation paradigm. You earlier set the map view delegate to self. So, when the map view is ready to display pins it will call the mapView:viewForAnnotation: method when a delegate is set and thus the app will get to the code you just defined.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //First, check if the annotation isn’t accidentally the user blip.
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        
        pin?.canShowCallout = true
        
        return pin
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FourSquareCell", forIndexPath: indexPath)
        
        return cell
        
    }


}

