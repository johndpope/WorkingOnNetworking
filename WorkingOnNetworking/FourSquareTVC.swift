//
//  ViewController.swift
//  WorkingOnNetworking
//
//  Created by GLR on 1/19/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import UIKit
import MapKit

class FourSquareTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FourSquareCell", forIndexPath: indexPath)
        
        return cell
        
    }


}

