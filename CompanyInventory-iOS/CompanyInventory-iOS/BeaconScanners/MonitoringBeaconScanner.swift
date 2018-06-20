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
        queueOfBeaconIds.maximumNumberOfElements = 7
    }
    
    override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beacons.forEach { (beacon) in
            beaconsIdsToScan?.forEach({ (beaconId) in
                if beaconId == "\(beacon.minor.intValue)", beacon.accuracy < 1 {
                    self.queueOfBeaconIds.enqueue(beacon.minor.intValue)
                    var counter = 0
                    for qElement in self.queueOfBeaconIds.list {
                        if qElement == beacon.minor.intValue {
                            counter += 1
                            if counter >= 3 {
                                self.queueOfBeaconIds = CustomQueue<Int>()
                                self.delegate?.foundBeacon(withId: "\(beacon.minor.intValue)")
                                return
                            }
                        }
                    }
                }
            })
        }
    }
}
