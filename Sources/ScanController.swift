//
//  ScanController.swift
//  blescan
//
//  Created by Hannes Ljungberg on 2018-06-26.
//  Copyright © 2018 Hannes Ljungberg. All rights reserved.
//

import Cocoa
import CoreBluetooth


class ScanController: NSObject, ScanManagerDelegate {
    private var manager: ScanManager?
    private var discoveredPeripheralIdentifiers: [UUID] = []


    init(manager: ScanManager) {
        super.init()
        self.manager = manager
        self.manager?.delegate = self
    }

    // MARK: ScanManagerDelegate

    func manager(_ manager: ScanManager, didDiscover periperal: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard discoveredPeripheralIdentifiers.contains(
            periperal.identifier) == false else { return }
        discoveredPeripheralIdentifiers.append(periperal.identifier)
        let identifier = "\(periperal.identifier.uuidString, .format(width: 36))"
        let rssi = "\(RSSI, .format(alignment: .right, width: 6))dB"
        let name = "\(periperal.name ?? "(unknown)")"
        print("\(identifier)\(rssi)   \(name)")
    
    }

    func managerReady(_ manager: ScanManager) {
        manager.startScan(advertisingWithServices: [])
        print("LE Scan ...")
    }

}
