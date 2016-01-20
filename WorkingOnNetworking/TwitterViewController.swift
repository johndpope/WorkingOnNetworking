//
//  TwitterViewController.swift
//  WorkingOnNetworking
//
//  Created by GLR on 1/19/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import UIKit
import CoreLocation

class TwitterViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var twitterTableView: UITableView!
    
    private var _shouldUpdateTrends = true
    private var _locationManager = CLLocationManager()
    var trends: [Trend] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let location = CLLocationManager().location
        {
            _shouldUpdateTrends = false
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
            _getTwitterTrendsWithCoordiate(coordinate)
        }
        else // location is not ready, so rely on locationManager:didUpdateLocations:
        {
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            _locationManager.startUpdatingLocation()
            _locationManager.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if _shouldUpdateTrends
        {
            _shouldUpdateTrends = false
            let userLocation = locations[0] as CLLocation
            let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude)
            
            _getTwitterTrendsWithCoordiate(coordinate)
        }
    }
    
    
    private func _getTwitterTrendsWithCoordiate(coordinate: CLLocationCoordinate2D)
    {
        print("get twitter trends with coordinate is being called")
        TwitterNetworkManager.findTrendingWoeIDForCoordinate(coordinate) { (woeID) -> () in
            
            if let id = woeID
            {
                print("found woe id: \(id)")
                TwitterNetworkManager.getTrendsForWoeID(id, completion: { (trends) -> Void in
                    for trend in trends {
                        print("trend.name:::::\(trend.name)")
                    }
                    self.trends = trends
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.twitterTableView.reloadData()
                    })
                })
            }
        }
    }
    
    func reloadTrends()   {
        trends.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
        
//        for i in 0..<trendLabels.count  {
//            trendLabels[i].text = "\(trends[i].name)\n\(trends[i].tweetVolume)"
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: TableView DataSource

extension TwitterViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int   {
        return trends.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell    {
        let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath)
        cell.textLabel!.text = trends[indexPath.row].name
        return cell
    }


    
}


// Mark: TableView Delegate

extension TwitterViewController {
    
    
}
