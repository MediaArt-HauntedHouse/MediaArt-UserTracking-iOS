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
    
    @IBOutlet weak var region: UILabel!

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
        
        let uuid:NSUUID? = NSUUID(UUIDString: "CB86BC31-05BD-40CC-903D-1C9BD13D966B")
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
            storyViewController.storyIndex = 1
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
                print(beacon)
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
