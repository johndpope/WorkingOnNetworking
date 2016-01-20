//
//  ViewController.swift
//  WorkingOnNetworking
//
//  Created by GLR on 1/19/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import UIKit
import MapKit

class FourSquareTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    let distanceSpan: Double = 500

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //the method has 3 parameters: the location manager that called the method, the new GPS location, and the old GPS location.
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            //a region is calculated from the new GPS coordinate and the distanceSpan (500 x 500) we created earlier with the newLocation coordinate in the center.
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FourSquareCell", forIndexPath: indexPath)
        
        return cell
        
    }


}

