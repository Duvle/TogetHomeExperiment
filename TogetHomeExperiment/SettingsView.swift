//
//  SettingsView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        @State var allBeaconNamespaceID: String = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17fd1cefff705e7f803e"
        @State var allBeaconNoRSSI: Int = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
        @State var allBeaconScanTime: Int = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
        
        NavigationStack {
            List {
                Section(header: Text("All Beacon Settings").bold()){
                    HStack{
                        Text("Namespace ID").frame(width: 140, alignment: .leading)
                        Divider()
                        TextField("20 Digits Hex Code", text: $allBeaconNamespaceID)
                    }
                    HStack{
                        Text("Number of RSSI").frame(width: 140, alignment: .leading)
                        Divider()
                        TextField("Natural Number", value: $allBeaconNoRSSI, format: .number)
                    }
                    HStack{
                        Text("Scan Time (sec)").frame(width: 140, alignment: .leading)
                        Divider()
                        TextField("Natural Number", value: $allBeaconScanTime, format: .number)
                    }
                }
                Section(header: Text("Specific Beacon").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                        Spacer()
                    }
                }
                Section(header: Text("Primary Beacon").bold()) {
                    HStack{
                        Spacer()
                        Text("Developing features...")
                            .font(.custom("SamsungOneKorean-400", size: 20))
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem {
                    Button {
                        UserDefaults.standard.set(allBeaconNamespaceID, forKey: "allBeaconNamespaceID")
                        UserDefaults.standard.set($allBeaconNoRSSI, forKey: "$allBeaconNoRSSI")
                        UserDefaults.standard.set($allBeaconScanTime, forKey: "$allBeaconScanTime")
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
