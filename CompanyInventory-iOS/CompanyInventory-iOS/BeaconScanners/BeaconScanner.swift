//
//  BeaconRanger.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol BeaconScannerDelegate: class {
    func foundBeacon(withId id: String)
}

class BeaconScanner: NSObject {
    
    private var beaconManager: ESTBeaconManager!
    private var regionToScan: CLBeaconRegion!
    
    weak var delegate: BeaconScannerDelegate?
    
    override init() {
        super.init()
        beaconManager = ESTBeaconManager()
        beaconManager.delegate = self
        beaconManager.requestWhenInUseAuthorization()
        regionToScan = defaultScanRegion()
    }

    func startMonitoring() {
        beaconManager.startMonitoring(for: regionToScan)
    }
    
    func stopMonitoring() {
        beaconManager.stopMonitoring(for: regionToScan)
    }
    
    func startRanging() {
        beaconManager.startRangingBeacons(in: regionToScan)
    }
    
    func stopRanging() {
        beaconManager.stopRangingBeacons(in: regionToScan)
    }
    
    private func defaultScanRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: UUID(uuidString: Constants.kBeaconProximityUid)!,
                              identifier: Constants.kBeaconIdentifier)
    }
    
}

extension BeaconScanner: ESTBeaconManagerDelegate {
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Implement logic for beacons that are received from beacon manager
    }
}
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        if region.proximityUUID.uuidString == Constants.kBeaconProximityUid && region.identifier == Constants.kBeaconIdentifier {
            delegate?.foundBeacon(withId: "")
        }
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        
    }
}
