//
//  MonitoringBeaconScanner.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/20/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class MonitoringBeaconScanner: BeaconScanner {
    
    private var beaconIdToScan: String?
    
    init(forBeaconId id: String?) {
        beaconIdToScan = id
    }
    
    override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beaconIdToScan = beaconIdToScan {
            print("Beacons:\n")
            for beacon in beacons {
                print("Minor: \(beacon.minor)\nProximity: \(beacon.proximity.rawValue)\nAccuracy: \(beacon.accuracy)\nRSSI: \(beacon.rssi)\n")
                
                if beacon.proximity != Constants.kBeaconMonitoringForbiddenProximity && beacon.accuracy < Constants.kBeaconMonitoringMinAccuracy && beaconIdToScan == "\(beacon.minor.intValue)" {
                    delegate?.foundBeacon(withId: beaconIdToScan)
                    return
                }
            }
            print("\n")
        }
    }
}
