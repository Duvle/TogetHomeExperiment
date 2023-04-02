//
//  BeaconView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

enum ViewOption {
    case all
    case specific
    case primary
}

struct BeaconOption {
    var mainTitle: String
    var subTitle: String
    var icon: String
    var targetView: ViewOption
}

struct BeaconScanResult {
    var instanceID: String
    var state: String
    var batteryLevel: Int
    var rssiData: [Int]
}

@ViewBuilder func viewSelect(for viewoption: ViewOption) -> some View {
    switch viewoption {
    case .all:
        BeaconAllView()
    case .specific:
        BeaconSpecView()
    case .primary:
        BeaconPriView()
    }
}

struct BeaconView: View {
    @State var optionList = [
        BeaconOption(mainTitle: "All Beacon", subTitle: "Find all the Toget-Home's Beacon Broadcast Data.", icon: "globe.asia.australia", targetView: .all),
        BeaconOption(mainTitle: "Specific Beacon", subTitle: "Find a specific Toget-Home's Beacon Broadcast Data.", icon: "square.split.bottomrightquarter", targetView: .specific),
        BeaconOption(mainTitle: "Primary Beacon", subTitle: "Find a primary Toget-Home's Beacon Broadcast Data.", icon: "flag.checkered.circle", targetView: .primary)
    ]
    var body: some View {
        NavigationStack {
            List(optionList, id: \.mainTitle) { optionListData in
                NavigationLink(
                    destination: viewSelect(for: optionListData.targetView),
                    label: {
                        HStack {
                            Image(systemName: optionListData.icon)
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color("BluetoothColor"))
                                .padding(10)
                            VStack {
                                Text(optionListData.mainTitle)
                                    .font(.custom("SamsungOneKorean-700", size: 35))
                                    .frame(width: 250, alignment: .leading)
                                    .padding(.bottom, 1)
                                Text(optionListData.subTitle)
                                    .font(.custom("SamsungOneKorean-400", size: 10))
                                    .frame(width: 250, alignment: .leading)
                            }
                        }
                    }).frame(height: 150)
            }.navigationTitle("Beacon")
        }
    }
}

struct BeaconAllView: View, BeaconScannerDelegate {
    @State var beaconScanner: BeaconScanner!
    @State var isScanning: Bool = false
    @State var beaconIDList: [String] = []
    @State var beaconScanDataList: [BeaconScanResult] = []
    
    var colorDictionary: [String : String] = [
        "Normal" : "BeaconNormalColor",
        "Triggered" : "BeaconTriggeredColor",
        "Low Battery" : "BeaconLowBatteryColor",
        "Default" : "BeaconDefaultColor"
    ]
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "FFFFFFFFFFFF"
        let _state = beaconInfo.beaconState?.deviceState
        let _batteryLevel = beaconInfo.beaconState?.batteryAmout ?? 0
        let _rssi = beaconInfo.RSSI
        
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
            stateString = "Unknown State"
        }
        
        if indexID != nil {
            if self.beaconScanDataList[indexID!].rssiData.count < 10 {
                self.beaconScanDataList[indexID!].rssiData.append(_rssi)
            }
        }
        else
        {
            self.beaconIDList.append(_instanceID)
            self.beaconScanDataList.append(BeaconScanResult(instanceID: _instanceID, state: stateString, batteryLevel: _batteryLevel, rssiData: [_rssi]))
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
            beaconIDList = []
            beaconScanDataList = []
        }
        .onAppear {
            self.beaconScanner = BeaconScanner()
            self.beaconScanner.delegate = self
        }
    }
}

struct BeaconSpecView: View {
    @State var isScanning: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Text("Developing features...")
                        .font(.custom("SamsungOneKorean-400", size: 20))
                    Spacer()
                }
            }
        }
        .navigationTitle("Specific Beacon")
        .toolbar {
            ToolbarItem {
                Button {
                    isScanning.toggle()
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
        }
    }
}

struct BeaconPriView: View {
    @State var isScanning: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Text("Developing features...")
                        .font(.custom("SamsungOneKorean-400", size: 20))
                    Spacer()
                }
            }
        }
        .navigationTitle("Primary Beacon")
        .toolbar {
            ToolbarItem {
                Button {
                    isScanning.toggle()
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
        }
    }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
