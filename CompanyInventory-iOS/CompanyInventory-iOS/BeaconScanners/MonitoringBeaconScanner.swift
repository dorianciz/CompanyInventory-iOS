//
//  MonitoringBeaconScanner.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/20/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class MonitoringBeaconScanner: BeaconScanner {
    
    var beaconsIdsToScan: [String]?
    
    private var queueOfBeaconIds = CustomQueue<Int>()
    
    init(withBeaconsIdsToScan beaconsIds: [String]?) {
        self.beaconsIdsToScan = beaconsIds
        queueOfBeaconIds.capacity = 7
    }
    
    override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("|---Scanned beacons: --- ID -------- ACCURACY -------- RSSI ---|\n\n")
        
        for beacon in beacons {
            print("                        \(beacon.minor)     \(beacon.accuracy)      \(beacon.rssi)")
            if let idsToScan = beaconsIdsToScan {
                for beaconId in idsToScan {
                    if beaconId == "\(beacon.minor.intValue)", beacon.accuracy < 1, beacon.accuracy >= 0 {
                        self.queueOfBeaconIds.enqueue(beacon.minor.intValue)
                        var counter = 0
                        for qElement in self.queueOfBeaconIds.list {
                            if qElement == beacon.minor.intValue {
                                counter += 1
                                if counter >= 4 {
                                    self.queueOfBeaconIds.emptyQueue()
                                    self.delegate?.foundBeacon(withId: "\(beacon.minor.intValue)")
                                    return
                                }
                            }
                        }
                        return
                    }
                }
            }
        }
        print("   List of scanned IDs: \(queueOfBeaconIds.list)")
        print("|-------------------------------------------------------------------|\n\n")
    }
}
