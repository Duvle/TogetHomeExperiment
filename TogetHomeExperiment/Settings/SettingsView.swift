//
//  SettingsView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct SettingsView: View {
    @State private var allBeaconNamespaceID: String = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
    @State private var allBeaconNoRSSI: Int = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
    @State private var allBeaconScanTime: Int = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
    
    @State private var testConnectionPort: String = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
    @State private var testConnectionUDPPort: String = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
    
    @State private var homeName: String = UserDefaults.standard.value(forKey: "homeName") as? String ?? ""
    @State private var intervalTime: Int = UserDefaults.standard.value(forKey: "intervalTime") as? Int ?? 60
    @State private var expireCount: Int = UserDefaults.standard.value(forKey: "expireCount") as? Int ?? 5
    @State private var isUserSet: Bool = UserDefaults.standard.value(forKey: "isUserSet") as? Bool ?? false
    @State private var userName: String = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
    @State private var userID: String = UserDefaults.standard.value(forKey: "userID") as? String ?? ""
    @State private var isDeviceSet: Bool = UserDefaults.standard.value(forKey: "isDeviceSet") as? Bool ?? false
    @State private var deviceName: String = UserDefaults.standard.value(forKey: "deviceName") as? String ?? ""
    @State private var deviceID: String = UserDefaults.standard.value(forKey: "deviceID") as? String ?? ""
    @State private var isSpaceSet: Bool = UserDefaults.standard.value(forKey: "isSpaceSet") as? Bool ?? false
    @State private var spaceID: String = UserDefaults.standard.value(forKey: "spaceID") as? String ?? ""
    
    @State private var appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    @State private var appBuild: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("All Beacon Settings").bold(),
                        footer: Text("NamespaceID should be represented by Hex String.")){
                    HStack{
                        Text("Namespace ID")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("20 Digits Hex Code", text: $allBeaconNamespaceID)
                    }
                    HStack{
                        Text("Number of RSSI")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("Natural Number", value: $allBeaconNoRSSI, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("Scan Time (sec)")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("Natural Number", value: $allBeaconScanTime, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: Text("Specific Beacon").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                Section(header: Text("Primary Beacon").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                Section(header: Text("Test Connect").bold(),
                        footer: Text("The ip address and port number must be entered correctly.")) {
                    HStack{
                        Text("Main Port")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("1024 ~ 49151", text: $testConnectionPort)
                    }
                    HStack{
                        Text("UDP Port")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("1024 ~ 49151", text: $testConnectionUDPPort)
                    }
                }
                Section(header: Text("Data Transfer").bold()) {
                    HStack{
                        Text("Home Name")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(homeName)")
                    }
                    HStack{
                        Text("Interval Time")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(intervalTime)")
                    }
                    HStack{
                        Text("Expire Count")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(expireCount)")
                    }
                    HStack{
                        Text("User Name")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(userName)")
                    }
                    HStack{
                        Text("User ID")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(isUserSet ? "True" : "False") => \(userID)")
                    }
                    HStack{
                        Text("Device Name")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(deviceName)")
                    }
                    HStack{
                        Text("Device ID")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(isDeviceSet ? "True" : "False") => \(deviceID)")
                    }
                    HStack{
                        Text("Space ID")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(isSpaceSet ? "True" : "False") => \(spaceID)")
                    }
                }
                Section(header: Text("Position Calculate").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                Section(header: Text("System Version").bold()) {
                    HStack{
                        Text("Version")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(appVersion)")
                    }
                    HStack{
                        Text("Build")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        Text("\(appBuild)")
                    }
                }
                Section(header: Text("Reset").bold(),
                        footer: Text("Initialize all data set for this application. Data stored on the server is not deleted.")) {
                    Button {
                        // Remove Part
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                        
                        // Load Part
                        self.allBeaconNamespaceID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
                        self.allBeaconNoRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
                        self.allBeaconScanTime = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
                        
                        self.testConnectionPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
                        self.testConnectionUDPPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
                        
                        self.homeName = UserDefaults.standard.value(forKey: "homeName") as? String ?? ""
                        self.intervalTime = UserDefaults.standard.value(forKey: "intervalTime") as? Int ?? 60
                        self.expireCount = UserDefaults.standard.value(forKey: "expireCount") as? Int ?? 5
                        self.isUserSet = UserDefaults.standard.value(forKey: "isUserSet") as? Bool ?? false
                        self.userName = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
                        self.userID = UserDefaults.standard.value(forKey: "userID") as? String ?? ""
                        self.isDeviceSet = UserDefaults.standard.value(forKey: "isDeviceSet") as? Bool ?? false
                        self.deviceName = UserDefaults.standard.value(forKey: "deviceName") as? String ?? ""
                        self.deviceID = UserDefaults.standard.value(forKey: "deviceID") as? String ?? ""
                        self.isSpaceSet = UserDefaults.standard.value(forKey: "isSpaceSet") as? Bool ?? false
                        self.spaceID = UserDefaults.standard.value(forKey: "spaceID") as? String ?? ""
                        
                        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                        self.appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
                    } label: {
                        Text("Reset All Data")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 350, height: 40)
                            .background(Color("BeaconDefaultColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                            .padding(5)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button {
                        hideKeyboard()
                        
                        UserDefaults.standard.setValue(allBeaconNamespaceID, forKey: "allBeaconNamespaceID")
                        UserDefaults.standard.setValue(allBeaconNoRSSI, forKey: "allBeaconNoRSSI")
                        UserDefaults.standard.setValue(allBeaconScanTime, forKey: "allBeaconScanTime")
                        
                        UserDefaults.standard.setValue(testConnectionPort, forKey: "testConnectionPort")
                        UserDefaults.standard.setValue(testConnectionUDPPort, forKey: "testConnectionUDPPort")
                        
                        UserDefaults.standard.setValue(homeName, forKey: "homeName")
                        UserDefaults.standard.setValue(intervalTime, forKey: "intervalTime")
                        UserDefaults.standard.setValue(expireCount, forKey: "expireCount")
                    } label: {
                        Text("Save")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 80, height: 30)
                            .background(Color("BeaconNormalColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(15)
                    }
                }
            }
            .onAppear {
                self.allBeaconNamespaceID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
                self.allBeaconNoRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
                self.allBeaconScanTime = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
                
                self.testConnectionPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
                self.testConnectionUDPPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
                
                self.homeName = UserDefaults.standard.value(forKey: "homeName") as? String ?? ""
                self.intervalTime = UserDefaults.standard.value(forKey: "intervalTime") as? Int ?? 60
                self.expireCount = UserDefaults.standard.value(forKey: "expireCount") as? Int ?? 5
                self.isUserSet = UserDefaults.standard.value(forKey: "isUserSet") as? Bool ?? false
                self.userName = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
                self.userID = UserDefaults.standard.value(forKey: "userID") as? String ?? ""
                self.isDeviceSet = UserDefaults.standard.value(forKey: "isDeviceSet") as? Bool ?? false
                self.deviceName = UserDefaults.standard.value(forKey: "deviceName") as? String ?? ""
                self.deviceID = UserDefaults.standard.value(forKey: "deviceID") as? String ?? ""
                self.isSpaceSet = UserDefaults.standard.value(forKey: "isSpaceSet") as? Bool ?? false
                self.spaceID = UserDefaults.standard.value(forKey: "spaceID") as? String ?? ""
                
                self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                self.appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
