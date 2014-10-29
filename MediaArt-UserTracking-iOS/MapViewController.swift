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
    
    var storyID = 0
    
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var majorID: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        let uuid:NSUUID? = NSUUID(UUIDString: "FF2BB40C-6C0E-1801-A386-001C4DB9EE23")
        let identifierStr:NSString = ""

        beaconRegion = CLBeaconRegion(proximityUUID:uuid, identifier:identifierStr)
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "storySegue") {
            let storyViewController: StoryViewController = segue.destinationViewController as StoryViewController
            storyViewController.storyIndex = storyID
        }
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
        
        manager.startMonitoringForRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion) {
        manager.requestStateForRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        switch (state) {
            case .Inside:
                manager.startRangingBeaconsInRegion(beaconRegion)
                self.region.text = "inside"
                break;
                
            case .Outside:
                self.region.text = "outside"
                break;
                
            case .Unknown:
                self.region.text = "unknown"
            default:                
                break;
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!){
        if(beacons.count > 0){
            for var i = 0; i < beacons.count; i++ {
                var beacon = beacons[i] as CLBeacon

                if (beacon.proximity == CLProximity.Unknown) {
                    self.distance.text = "Unknown Proximity"
                    return
                } else if (beacon.proximity == CLProximity.Immediate) {
                    self.distance.text = "Immediate"
                } else if (beacon.proximity == CLProximity.Near) {
                    self.distance.text = "Near"
                } else if (beacon.proximity == CLProximity.Far) {
                    self.distance.text = "Far"
                }
                self.majorID.text = "\(beacon.major)"
                storyID = Int(beacon.major)
                
            }
        }else{
            print("beacon not found")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(beaconRegion)
    }
}
