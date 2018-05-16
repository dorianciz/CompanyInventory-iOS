//
//  NearestBeaconScanner.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class NearestBeaconScanner: BeaconScanner {
    private var queueOfBeaconIds = CustomQueue<Int>()
    
    override init() {
        super.init()
        queueOfBeaconIds.maximumNumberOfElements = 7
    }
    
    override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("Beacons:\n")
        if region.proximityUUID.uuidString == Constants.kBeaconProximityUid && region.identifier == Constants.kBeaconIdentifier {
            
            for beacon in beacons {
                print("Minor: \(beacon.minor)\nProximity: \(beacon.proximity.rawValue)\nAccuracy: \(beacon.accuracy)\nRSSI: \(beacon.rssi)\n")
            }
            print("\n")
            // FIXME: Improve the algorithm
            if let nearestBeacon = beacons.first {
                if nearestBeacon.proximity == Constants.kBeaconMinProximity && nearestBeacon.accuracy < Constants.kBeaconMinAccuracy && nearestBeacon.rssi > Constants.kBeaconMinRSSI {
                    queueOfBeaconIds.enqueue(nearestBeacon.minor.intValue)
                    var counter = 0
                    for qElement in queueOfBeaconIds.list {
                        if qElement == nearestBeacon.minor.intValue {
                            counter += 1
                            if counter >= 3 {
                                delegate?.foundBeacon(withId: "\(nearestBeacon.minor.intValue)")
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
}
