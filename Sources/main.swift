//
//  main.swift
//  blescan
//
//  Created by Hannes Ljungberg on 2018-06-24.
//  Copyright © 2018 Hannes Ljungberg. All rights reserved.
//

import Cocoa

let manager = BluetoothScanManager()
let controller = ScanController(manager: manager)

RunLoop.main.run()
