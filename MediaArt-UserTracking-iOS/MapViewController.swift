//
//  MapViewController.swift
//  MediaArt-UserTracking-iOS
//
//  Created by Masaki Kobayashi on 2014/10/28.
//  Copyright (c) 2014年 Masaki Kobayashi. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var beaconRegion:CLBeaconRegion!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .Authorized:
            statusStr = "Authorized"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(statusStr)
        
        manager.startMonitoringForRegion(beaconRegion);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestAlwaysAuthorization();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "storySegue") {
            let storyViewController: StoryViewController = segue.destinationViewController as StoryViewController
            storyViewController.storyIndex = 1
        }
    }
}
