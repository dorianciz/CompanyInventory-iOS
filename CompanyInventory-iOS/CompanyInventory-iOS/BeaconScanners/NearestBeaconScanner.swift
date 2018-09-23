//
//  NearestBeaconScanner.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class NearestBeaconScanner: BeaconScanner {
    
    var inventoryBrain = InventoryBrain()
    var inventoryId: String?
    var inventoryByDateId: String?
    
    private var queueOfBeaconIds = CustomQueue<Int>()
    private var beaconIds: [String]?
    
    override init() {
        super.init()
        queueOfBeaconIds.capacity = 7
        beaconIds = [String]()
    }
    
    init(withInventoryId inventoryId: String?, withInventoryByDateId inventoryByDateId: String?) {
        queueOfBeaconIds.capacity = 7
        if let inventoryId = inventoryId, let inventoryByDateId = inventoryByDateId {
            beaconIds = inventoryBrain.getUsedBeaconIdsFromLocalItems(forInventoryId: inventoryId, forInventoryByDateId: inventoryByDateId)
        } else {
            beaconIds = [String]()
        }
    }
    
    override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("Beacons:\n")
        if region.proximityUUID.uuidString == Constants.kBeaconProximityUid && region.identifier == Constants.kBeaconIdentifier {
            
            for nearestBeacon in beacons {
                print("Minor: \(nearestBeacon.minor)\nProximity: \(nearestBeacon.proximity.rawValue)\nAccuracy: \(nearestBeacon.accuracy)\nRSSI: \(nearestBeacon.rssi)\n")
                
                //Check if beacon is already used
                var beaconUsed = false
                for beaconId in beaconIds! {
                    if beaconId == "\(nearestBeacon.minor.intValue)" {
                        beaconUsed = true
                        break
                    }
                }
                
                if nearestBeacon.proximity == Constants.kBeaconMinProximity && nearestBeacon.accuracy < Constants.kBeaconMinAccuracy && nearestBeacon.rssi > Constants.kBeaconMinRSSI && !beaconUsed {
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
            print("\n")
        }
    }
    
}
