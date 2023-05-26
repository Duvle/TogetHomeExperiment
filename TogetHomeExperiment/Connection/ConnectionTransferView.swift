//
//  ConnectionTransferView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/08.
//

import SwiftUI

struct ConnectionTransferView: View, MainStationConnectorDelegate {
    @State var connector: MainStationConnector!
    
    @State private var isHomeSetupView: Bool = false
    @State private var isServerFind: Bool = false
    @State private var isServerConnectToggle: Bool = false
    @State private var isServerConnect: Bool = false
    @State private var isError: Bool = false
    
    @State private var mainPort: String?
    @State private var udpPort: String?
    
    func readyConnector(connector: MainStationConnector) {
        self.isServerFind = true
    }
    func didConnected(connector: MainStationConnector) {
        self.isServerConnect = true
        self.isServerConnectToggle = true
    }
    func didConnectError(connector: MainStationConnector) {
        self.isError = true
    }
    func didDisconnected(connector: MainStationConnector) {
        self.isServerConnect = false
        self.isServerConnectToggle = false
    }
    
    var body: some View {
        List {
            Section(header: Text("Server State").bold()) {
                HStack{
                    Spacer()
                    Text(isServerFind ? (isError ? "Connection Error!!" : (isServerConnect ? "Connected" : "Disconnected")) : "Waiting" )
                        .font(.custom("SamsungOneKorean-400", size: 20))
                        .bold()
                        .foregroundColor(Color(isServerFind ? (isError ? "BeaconTriggeredColor" : (isServerConnect ? "BeaconNormalColor" : "ScanStopColor")) : "BeaconDefaultColor" ))
                    Spacer()
                }
            }
            
            Section(header: Text("Home Settings").bold()) {
                VStack {
                    HStack {
                        HStack{
                            Image(systemName: "house")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(5)
                            Image(systemName: "plus.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        Text("Home Setup")
                            .font(.custom("SamsungOneKorean-700", size: 20))
                            .frame(width: 250, alignment: .leading)
                            .padding(.bottom, 1)
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Button {
                            isHomeSetupView.toggle()
                        } label: {
                            Text(">")
                                .font(.custom("SamsungOneKorean-600", size: 17))
                                .frame(width: 200, alignment: .trailing)
                                .foregroundColor(Color("BeaconDefaultColor"))
                        }
                        .sheet(isPresented: $isHomeSetupView) {
                            HomeSetupView(connector: self.$connector)
                        }
                        .disabled(!isServerConnect)
                    }
                }
                
            }
            HStack{
                Spacer()
                Text("Developing features...")
                    .font(.custom("SamsungOneKorean-400", size: 20))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .navigationTitle("Data Transfer")
        .toolbar {
            ToolbarItem {
                Button {
                    isServerConnectToggle.toggle()
                    if isServerConnectToggle {
                        self.connector.setConnect()
                    }
                    else {
                        self.connector.setDisconnect()
                    }
                } label: {
                    Text(isServerFind ? (isServerConnect ? "Disconnection" : "Connection") : "Waiting" )
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 130, height: 30)
                        .background(isServerFind ? (isServerConnect ? Color("ScanStopColor") : Color("ScanStartColor")) : Color("ScanWaitColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(15)
                }
                .disabled(!isServerFind)
            }
        }
        .onAppear {
            self.mainPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
            self.udpPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
            
            self.connector = MainStationConnector(mainPort: self.mainPort, udpPort: self.udpPort)
            self.connector.delegate = self
        }
        .onDisappear {
            if isServerFind {
                self.connector.setDisconnect()
            }
        }
    }
}

struct HomeSetupView: View {
    @Binding var connector: MainStationConnector!
    
    @State private var responseValues: [String : Any] = [:]
    @State private var homeName: String = ""
    @State private var isAlreadyHome: Bool = false
    
    var body: some View {
        VStack {
            Image("BeaconHomeImg")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 500)
                .offset(x: -13)
            
            HStack {
                Image("TogetHomeHLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("Welcome! \nToget Home World.")
                    .font(.custom("SamsungOneKorean-700", size: 32))
                    .frame(alignment: .leading)
                
            }
            .frame(height: 130)
            
            HStack{
                Text("Home Name")
                    .frame(width: 120, alignment: .leading)
                    .foregroundColor(.gray)
                    .bold()
                Divider()
                TextField("Your Home Name", text:$homeName)
                    .frame(width: 200, alignment: .leading)
            }
            .frame(width: 400, height: 40)
            .background(Color("BackgroundColor"))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .padding(5)
            Button {
                
            } label: {
                Text(isAlreadyHome ? "Start" : "Set the home name and Start")
                    .font(.custom("SamsungOneKorean-700", size: 18))
                    .frame(width: 400, height: 40)
                    .background(isAlreadyHome ? Color("BeaconTriggeredColor") : Color("BeaconNormalColor"))
                    .foregroundColor(Color("BackgroundColor"))
                    .cornerRadius(20)
            }
        }
        .onAppear {
            Task {
                self.responseValues = try await self.connector.homeCheck()
                self.isAlreadyHome = responseValues["valid"] as! Bool
                NSLog("HomeCheck Result => \(isAlreadyHome)")
                
                if self.isAlreadyHome {
                    self.homeName = responseValues["home_name"] as! String
                }
            }
        }
    }
}

struct ConnectionTransferView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionTransferView()
    }
}
