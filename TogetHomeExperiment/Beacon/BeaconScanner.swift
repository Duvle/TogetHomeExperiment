//
//  BeaconScanner.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/02.
//

import Foundation
import CoreBluetooth

protocol BeaconScannerDelegate {
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo)
}

class BeaconScanner: NSObject, CBCentralManagerDelegate {
    
    var delegate: BeaconScannerDelegate?
    var onLostTimeout: Double = 15.0
    
    private var centralManager: CBCentralManager!
    private let beaconOperationsQueue = DispatchQueue(label: "beacon_operation_queue")
    private var shoudBeScanning = false
    
    private var seenEddystoneCache = [String : [String : AnyObject]]()
    private var deviceIDCache = [UUID : NSData]()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: beaconOperationsQueue)
        self.centralManager.delegate = self
    }
    
    // Start Scanning
    public func startScanning() {
        if self.centralManager.state != .poweredOn {
            NSLog("CentralManager state %d, Can't Start Scanning", self.centralManager.state.rawValue)
            self.shoudBeScanning = true
        }
        else {
            NSLog("Start Scanning")
            let services = [CBUUID(string: "FEAA")]
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
            self.centralManager.scanForPeripherals(withServices: services, options: options)
        }
    }
    
    // Stop Scanning
    public func stopScanning() {
        NSLog("Stop Scanning")
        self.centralManager.stopScan()
    }
    
    // Delegate Callbacks
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn && self.shoudBeScanning {
            self.startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [NSObject : AnyObject] {
            var type: BeaconInfo.EddystoneFrameType
            type = BeaconInfo.frameTypefromData(advertisementFrameList: serviceData)
            
            if type == BeaconInfo.EddystoneFrameType.UID {
                let serviceUUID = CBUUID(string: "FEAA")
                let _RSSI: Int = RSSI.intValue
                if let beaconServiceData = serviceData[serviceUUID] as? NSData,
                   let beaconInfo = BeaconInfo.beaconInfoFromData(frameData: beaconServiceData, RSSI: _RSSI) {
                    self.delegate?.didFindBeacon(beaconScanner: self, beaconInfo: beaconInfo)
                }
            }
        }
    }
}
