//
//  ScanManager.swift
//  blescan
//
//  Created by Hannes Ljungberg on 2018-06-25.
//  Copyright © 2018 Hannes Ljungberg. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol ScanManagerDelegate: class {
    func manager(_ manager: ScanManager, didDiscover periperal: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    func managerReady(_ manager: ScanManager)
}


protocol ScanManager: class {
    var delegate: ScanManagerDelegate? { get  set }
    func startScan(advertisingWithServices services: [String])
    func stopScan()
}

class BluetoothScanManager: NSObject, ScanManager, CBCentralManagerDelegate {
    // MARK: Properties
    weak var delegate: ScanManagerDelegate?

    private(set) var scanning = false
    private(set) var centralManager: CBCentralManager?
    private static let dispatchQueueLabel = "se.hannesljungberg.blescan"
    private let dispatchQueue = DispatchQueue(label: dispatchQueueLabel, attributes: [])


    // MARK: Initializers

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: dispatchQueue)
    }
    
    // MARK: Public methods

    func startScan(advertisingWithServices services: [String] = []) {
        guard scanning != true else {
            return
        }
        scanning = true
        let cbuuids = services.map { CBUUID(string: $0) }
        centralManager?.scanForPeripherals(
            withServices: cbuuids,
            options: nil
        )
    }

    func stopScan() {
        scanning = false
        centralManager?.stopScan()
    }

    // MARK: CBCentralManagerDelegate

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.manager(self, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            delegate?.managerReady(self)
            break
        default:
            return
        }
    }
}
