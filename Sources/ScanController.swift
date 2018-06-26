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
        print("\(periperal.identifier) \(periperal.name ?? "(unknown)")")
    }

    func managerReady(_ manager: ScanManager) {
        manager.startScan(advertisingWithServices: [])
        print("LE Scan ...")
    }

}
