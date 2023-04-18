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
    
    @State private var testConnectionIP: String = UserDefaults.standard.value(forKey: "testConnectionIP") as? String ?? "127.0.0.1"
    @State private var testConnectionPort: String = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
    
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
                    }
                    HStack{
                        Text("Scan Time (sec)")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("Natural Number", value: $allBeaconScanTime, format: .number)
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
                        Text("IP Address")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("IPv4 Format", text: $testConnectionIP)
                    }
                    HStack{
                        Text("Port Number")
                            .frame(width: 140, alignment: .leading)
                            .foregroundColor(.gray)
                            .bold()
                        Divider()
                        TextField("1024 ~ 49151", text: $testConnectionPort)
                    }
                }
                Section(header: Text("Data Transfer").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                            .foregroundColor(.gray)
                        Spacer()
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
            }
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem {
                    Button {
                        UserDefaults.standard.setValue(allBeaconNamespaceID, forKey: "allBeaconNamespaceID")
                        UserDefaults.standard.setValue(allBeaconNoRSSI, forKey: "allBeaconNoRSSI")
                        UserDefaults.standard.setValue(allBeaconScanTime, forKey: "allBeaconScanTime")
                        UserDefaults.standard.setValue(testConnectionIP, forKey: "testConnectionIP")
                        UserDefaults.standard.setValue(testConnectionPort, forKey: "testConnectionPort")
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
