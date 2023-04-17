//
//  BeaconAllView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/18.
//

import SwiftUI

struct BeaconScanResult {
    var instanceID: String
    var state: String
    var batteryLevel: Int
    var txPower: Int
    var rssiData: [Int]
}

struct BeaconAllView: View, BeaconScannerDelegate {
    @State var beaconScanner: BeaconScanner!
    @State var isScanning: Bool = false
    @State var beaconIDList: [String] = []
    @State var beaconScanDataList: [BeaconScanResult] = []
    
    @State private var searchID: String = ""
    @State private var noRSSI: Int = 10
    @State private var time: Int = 60
    
    var colorDictionary: [String : String] = [
        "Normal" : "BeaconNormalColor",
        "Triggered" : "BeaconTriggeredColor",
        "Low Battery" : "BeaconLowBatteryColor",
        "Default" : "BeaconDefaultColor"
    ]
    
    // If find the Eddystone Beacon Data
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _namespaceID = beaconInfo.beaconID?.idtostring(idType: .Namespace) ?? "17fd1cefff705e7f803e"
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "ffffffffffff"
        let _state = beaconInfo.beaconState?.deviceState
        let _batteryLevel = beaconInfo.beaconState?.batteryAmout ?? 0
        let _rssi = (beaconInfo.RSSI < -100 || beaconInfo.RSSI > 0) ? -100 : beaconInfo.RSSI
        let _txPower = beaconInfo.txPower
        
        let indexID = self.beaconIDList.firstIndex(of: _instanceID)
        let stateString: String
        
        switch _state {
        case .Normal:
            stateString = "Normal"
        case .Triggered:
            stateString = "Triggered"
        case .LowBattery:
            stateString = "Low Battery"
        case .Unknown:
            stateString = "Unknown State"
        default:
            stateString = "Default"
        }
        
        if _namespaceID == self.searchID {
            if indexID != nil {
                if self.beaconScanDataList[indexID!].rssiData.count < noRSSI {
                    self.beaconScanDataList[indexID!].rssiData.append(_rssi)
                }
            }
            else
            {
                self.beaconIDList.append(_instanceID)
                self.beaconScanDataList.append(BeaconScanResult(instanceID: _instanceID, state: stateString, batteryLevel: _batteryLevel, txPower: _txPower, rssiData: [_rssi]))
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if beaconScanDataList.isEmpty {
                List {
                    HStack{
                        Spacer()
                        Text("No Beacons")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .foregroundColor(Color("BeaconDefaultColor"))
                        Spacer()
                    }
                }
            }
            else {
                List(beaconScanDataList, id: \.instanceID) { beaconData in
                    HStack {
                        Image(systemName: "wave.3.right.circle.fill")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(Color(colorDictionary[beaconData.state] ?? "BeaconDefaultColor"))
                            .padding(5)
                        VStack {
                            Text("ID : \(beaconData.instanceID)")
                                .font(.custom("SamsungOneKorean-600", size: 20))
                                .frame(width: 300, alignment: .leading)
                                .padding(.bottom, 1)
                            Text("State : \(beaconData.state)\nBattery : \(beaconData.batteryLevel)%")
                                .font(.custom("SamsungOneKorean-400", size: 15))
                                .frame(width: 300, alignment: .leading)
                                .padding(.bottom, 1)
                            Text("RSSI at 1m : \(beaconData.txPower)")
                                .font(.custom("SamsungOneKorean-200", size: 10))
                                .frame(width: 300, alignment: .leading)
                                .padding(.bottom, 1)
                            Text("RSSI : \(beaconData.rssiData.map(String.init).joined(separator: " "))")
                                .font(.custom("SamsungOneKorean-200", size: 10))
                                .frame(width: 300, alignment: .leading)
                                .padding(.bottom, 1)
                        }
                    }
                }
            }
        }
        .navigationTitle("All Beacon")
        .toolbar {
            ToolbarItem {
                Button {
                    isScanning.toggle()
                    if isScanning {
                        self.beaconScanner.startScanning()
                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(time)) {
                            isScanning = false
                            self.beaconScanner.stopScanning()
                        }
                    }
                    else {
                        self.beaconScanner.stopScanning()
                    }
                } label: {
                    Text(isScanning ? "Stop" : "Scan")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 80, height: 30)
                        .background(isScanning ? Color("ScanStopColor") : Color("ScanStartColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(15)
                }
            }
        }
        .refreshable {
            isScanning = false
            self.beaconScanner.stopScanning()
            beaconIDList = []
            beaconScanDataList = []
            
            self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
            self.noRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
            self.time = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
        }
        .onAppear {
            self.beaconScanner = BeaconScanner()
            self.beaconScanner.delegate = self
            
            self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
            self.noRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
            self.time = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
        }
    }
}

struct BeaconAllView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconAllView()
    }
}
