//
//  ConnectionCalculateView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/08.
//

import SwiftUI

struct storedBeaconList {
    var id: String
    var stateHex: String
    var rssi: [Int]
}

struct ConnectionCalculateView: View, MainStationConnectorDelegate, BeaconScannerDelegate {
    @State var connector: MainStationConnector!
    @State var beaconScanner: BeaconScanner!
    
    @State var timeTrigger: Bool = true
    @State var realTime: Timer!
    
    @State private var searchID: String = ""
    @State private var noRSSI: Int = 10
    @State private var intervalTime: Int = 60
    @State private var expiredCount: Int = 5
    
    @State private var responseValues: [String : Any] = [:]
    @State private var responseList: [[String : Any]] = []
    
    @State private var loadBeaconList: [String] = []
    @State private var setBeaconList: [String] = []
    @State private var beaconList: [storedBeaconList] = []
    
    @State private var isDeviceSet: Bool = false
    @State private var deviceID: String = ""
    @State private var deviceName: String = ""
    @State private var userID: String = ""
    
    @State private var spaceID: String = ""
    @State private var spaceName: String = ""
    @State private var posX: Float = 0
    @State private var posY: Float = 0
    
    @State private var isToggled: Bool = false
    @State private var isSetup: Bool = false
    @State private var isStart: Bool = false
    @State private var isServerFind: Bool = false
    @State private var isServerConnect: Bool = false
    @State private var isScanning: Bool = false
    @State private var isError: Bool = false
    @State private var isFistScanning: Bool = false
    @State private var isSecondScanning: Bool = false
    
    @State private var mainPort: String?
    @State private var udpPort: String?
    
    @State private var message: String = "Unknown"
    
    func readyConnector(connector: MainStationConnector) {
        self.isServerFind = true
    }
    func didConnected(connector: MainStationConnector) {
        self.isServerConnect = true
        self.deviceSetup()
        self.startup()
    }
    func didConnectError(connector: MainStationConnector) {
        self.isError = true
    }
    func didDisconnected(connector: MainStationConnector) {
        self.isServerConnect = false
        self.isToggled = false
    }
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _namespaceID = beaconInfo.beaconID?.idtostring(idType: .Namespace) ?? "17FD1CEFFF705E7F803E"
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "FFFFFFFFFFFF"
        let _stateHex = beaconInfo.beaconState?.deviceStateHex ?? "FFFF"
        let _rssi = (beaconInfo.RSSI < -120 || beaconInfo.RSSI > 0) ? -120 : beaconInfo.RSSI
        
        let indexID = self.setBeaconList.firstIndex(of: _instanceID)
        let checkID = self.loadBeaconList.firstIndex(of: _instanceID)
        
        if (_namespaceID == self.searchID) && (checkID != nil) {
            if indexID != nil {
                if self.beaconList[indexID!].rssi.count < self.noRSSI {
                    self.beaconList[indexID!].rssi.append(_rssi)
                }
            }
            else {
                self.setBeaconList.append(_instanceID)
                self.beaconList.append(storedBeaconList(id: _instanceID, stateHex: _stateHex, rssi: [_rssi]))
            }
        }
    }
    
    func deviceSetup() {
        Task {
            self.responseValues = try await self.connector.deviceReRegister(deviceID: self.deviceID, deviceName: self.deviceName, userID: self.userID)
            let isSuccess: Bool = self.responseValues["valid"] as! Bool
            
            if isSuccess {
                self.isSetup = true
            }
            else {
                self.isSetup = false
                self.message = self.responseValues["msg"] as! String
                isError.toggle()
            }
        }
    }
    
    func ipsStartup() {
        self.isStart = false
        self.isFistScanning = false
        self.isSecondScanning = false
        self.loadBeaconList = []
        self.setBeaconList = []
        self.beaconList = []
        
        Task {
            self.isStart = true
            
            // Load Primary Beacon
            self.responseList = try await self.connector.beaconPriRequest()
            let isLoadPrimarySuccess: Bool = self.responseList[0]["valid"] as! Bool
            
            if isLoadPrimarySuccess {
                for primaryBeaconData: [String : Any] in responseList {
                    self.loadBeaconList.append(primaryBeaconData["id"] as! String)
                }
            }
            else {
                self.message = self.responseList[0]["msg"] as! String
                isError.toggle()
                return
            }
            
            // Fist IPS
            self.beaconScanner.startScanning()
            self.isScanning = true
            try await Task.sleep(nanoseconds: UInt64((intervalTime / 3) * 1_000_000_000))
            self.isScanning = false
            self.beaconScanner.stopScanning()
            
            for checkBeaconData in self.loadBeaconList {
                let indexID = self.setBeaconList.firstIndex(of: checkBeaconData)
                if indexID == nil {
                    self.setBeaconList.append(checkBeaconData)
                    self.beaconList.append(storedBeaconList(id: checkBeaconData, stateHex: "60FF", rssi: [-100]))
                }
            }
            
            var firstRssiData: [[String : Any]] = []
            for primaryBeaconData in self.beaconList {
                firstRssiData.append(["id": primaryBeaconData.id, "state": primaryBeaconData.stateHex, "rssi": primaryBeaconData.rssi])
            }
            self.responseValues = try await self.connector.ipsSpaceRequest(beaconRssiData: firstRssiData)
            let isFisrtIPSSuccess: Bool = self.responseValues["valid"] as! Bool
            
            if isFisrtIPSSuccess {
                self.spaceID = self.responseValues["space_id"] as! String
                self.isFistScanning = true
            }
            else {
                self.message = responseValues["msg"] as! String
                isError.toggle()
                return
            }
            
            // Load Space Name
            self.spaceName = ""
            
            self.responseList = try await self.connector.spaceRequest()
            let isLoadSpaceNameSuccess: Bool = self.responseList[0]["valid"] as! Bool
            
            if isLoadSpaceNameSuccess {
                for spaceData in self.responseList {
                    if spaceData["id"] as! String == self.spaceID {
                        self.spaceName = spaceData["familiar_name"] as! String
                    }
                }
            }
            else {
                self.message = responseValues["msg"] as! String
                isError.toggle()
                return
            }
            
            // Load Specific Beacon
            self.loadBeaconList = []
            self.setBeaconList = []
            self.beaconList = []
            
            self.responseList = try await self.connector.beaconSpaceRequest(spaceID: self.spaceID)
            let isLoadSpecificBeaconSuccess: Bool = self.responseList[0]["valid"] as! Bool
            
            if isLoadSpecificBeaconSuccess {
                for specificBeaconData: [String : Any] in responseList {
                    self.loadBeaconList.append(specificBeaconData["id"] as! String)
                }
            }
            else {
                self.message = self.responseList[0]["msg"] as! String
                isError.toggle()
            }
            
            // Final IPS
            self.beaconScanner.startScanning()
            self.isScanning = true
            try await Task.sleep(nanoseconds: UInt64((intervalTime / 3) * 1_000_000_000))
            self.isScanning = false
            self.beaconScanner.stopScanning()
            
            for checkBeaconData in self.loadBeaconList {
                let indexID = self.setBeaconList.firstIndex(of: checkBeaconData)
                if indexID == nil {
                    self.setBeaconList.append(checkBeaconData)
                    self.beaconList.append(storedBeaconList(id: checkBeaconData, stateHex: "60FF", rssi: [-100]))
                }
            }
            
            var finalRssiData: [[String : Any]] = []
            
            for specificBeaconData in self.beaconList {
                finalRssiData.append(["id": specificBeaconData.id, "state": specificBeaconData.stateHex, "rssi": specificBeaconData.rssi])
            }
            
            self.connector.ipsFinalRequest(spaceID: self.spaceID, beaconRssiData: finalRssiData)
            self.isSecondScanning = true
            
            // Load Position Data
            self.posX = 0
            self.posY = 0
            
            self.responseValues = try await self.connector.positionDeviceRequest(deviceID: self.deviceID)
            let isLoadPositionDataSuccess: Bool = self.responseValues["valid"] as! Bool
            
            if isLoadPositionDataSuccess {
                self.posX = (self.responseValues["pos_x"] as! NSNumber).floatValue
                self.posY = (self.responseValues["pos_y"] as! NSNumber).floatValue
            }
            else {
                self.message = responseValues["msg"] as! String
                isError.toggle()
                return
            }
        }
    }
    
    func startup() {
        self.realTime = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.intervalTime), repeats: true) { timer in
            if isSetup {
                self.ipsStartup() // Work
            }
        }
    }
    
    func stopAll() {
        if self.realTime != nil {
            if self.realTime.isValid {
                self.realTime.invalidate()
            }
        }
        
        if isScanning {
            self.beaconScanner.stopScanning()
            self.isScanning = false
        }
        if isServerConnect {
            self.connector.setDisconnect()
            self.isServerConnect = false
            self.isSetup = false
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Image("BeaconHomeImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 300)
                    .offset(x: -12, y: 10)
                    .padding(.bottom, 30.0)
                
                // Controller Part
                Section(header: Text("IPS State").bold()) {
                    HStack{
                        Spacer()
                        Text(isDeviceSet ? (isServerFind ? (isServerConnect ? (isStart ? (isFistScanning ? (isSecondScanning ? "Done" : "Position Calculation") : "Space Calculation") : "Loading...") : "Ready to Start!") : "Server Waiting...") : "Unable to IPS")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .bold()
                            .foregroundColor(isDeviceSet ? (isServerFind ? (isServerConnect ? (isStart ? (isFistScanning ? (isSecondScanning ? Color("BeaconNormalColor") : Color("BeaconTriggeredColor")) : Color("BeaconTriggeredColor")) : Color("ScanStartColor")) : Color("BeaconNormalColor")) : Color("BeaconDefaultColor")) : Color("BeaconDefaultColor"))
                        Spacer()
                    }
                }
                
                Section(header: Text("IPS Controller").bold()) {
                    Button {
                        if !isServerFind {
                            self.connector = MainStationConnector(mainPort: self.mainPort, udpPort: self.udpPort)
                            self.connector.delegate = self
                            
                            self.beaconScanner = BeaconScanner()
                            self.beaconScanner.delegate = self
                        }
                        else {
                            isToggled.toggle()
                            
                            if isToggled {
                                self.connector.setConnect()
                            }
                            else {
                                self.stopAll()
                            }
                        }
                    } label: {
                        Text(isDeviceSet ? (isServerFind ? (isToggled ? "Stop" : "Start") : "Wait") : "Unable")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 350, height: 40)
                            .background(isServerFind ? (isToggled ? Color("ScanStopColor") : Color("ScanStartColor")) : Color("BeaconDefaultColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                            .padding(5)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(!isDeviceSet)
                }
                
                Section(header: Text("Position Result").bold(),
                        footer: Text("The result of tracking the interior position of the device. There may be an error of 1 to 2 meters from the actual location.")) {
                    HStack{
                        Text("Space Name")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(self.spaceName)")
                    }
                    HStack{
                        Text("Position")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("Position X : \(String(format: "%.2f", self.posX))m, Position Y : \(String(format: "%.2f", self.posY))m")
                    }
                }
            }
        }
        .navigationTitle("Position Calculate")
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { self.stopAll() }))
        }
        .onAppear {
            self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17FD1CEFFF705E7F803E"
            self.noRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
            self.intervalTime = UserDefaults.standard.value(forKey: "intervalTime") as? Int ?? 60
            self.expiredCount = UserDefaults.standard.value(forKey: "expiredCount") as? Int ?? 5
            
            self.isDeviceSet = UserDefaults.standard.value(forKey: "isDeviceSet") as? Bool ?? false
            self.deviceID = UserDefaults.standard.value(forKey: "deviceID") as? String ?? ""
            self.deviceName = UserDefaults.standard.value(forKey: "deviceName") as? String ?? ""
            self.userID = UserDefaults.standard.value(forKey: "userID") as? String ?? ""
            
            self.mainPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
            self.udpPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
            
            if !isDeviceSet {
                self.message = responseValues["msg"] as! String
                isError.toggle()
            }
        }
        .onDisappear {
            self.stopAll()
        }
    }
}

struct ConnectionCalculateView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionCalculateView()
    }
}
