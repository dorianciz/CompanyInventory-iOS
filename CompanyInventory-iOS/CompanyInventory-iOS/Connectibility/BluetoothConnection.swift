//
//  BluetoothConnection.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/23/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class BluetoothConnection: NSObject {
    
    private let bluetoothManager = CBCentralManager()
    var currentBluetoothState: CBManagerState?
    
    override init() {
        super.init()
        bluetoothManager.delegate = self
    }
    
}

extension BluetoothConnection: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        currentBluetoothState = central.state
    }
}
