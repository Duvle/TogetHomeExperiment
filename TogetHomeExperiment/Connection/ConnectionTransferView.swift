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
    @State private var isOptionUpdateView: Bool = false
    @State private var isUserSetupView: Bool = false
    @State private var isDeviceSetupView: Bool = false
    @State private var isSpaceRegisterView: Bool = false
    @State private var isSpaceUpdateView: Bool = false
    @State private var isSpaceSetupView: Bool = false
    @State private var isBeaconRegisterView: Bool = false
    @State private var isBeaconUpdateView: Bool = false
    @State private var isBeaconPowerUpdateView: Bool = false
    @State private var isPrimaryBeaconSetupView: Bool = false
    
    @State private var isServerFind: Bool = false
    @State private var isServerConnectToggle: Bool = false
    @State private var isServerConnect: Bool = false
    @State private var isError: Bool = false
    
    @State private var mainPort: String?
    @State private var udpPort: String?
    
    @State private var message: String = "Unknown"
    
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
        NavigationStack {
            List {
                // Server Part
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
                
                Section(header: Text("Server Connector").bold()) {
                    Button {
                        if !isServerFind {
                            self.mainPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
                            self.udpPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
                            
                            self.connector = MainStationConnector(mainPort: self.mainPort, udpPort: self.udpPort)
                            self.connector.delegate = self
                        }
                        else {
                            isServerConnectToggle.toggle()
                            if isServerConnectToggle {
                                self.connector.setConnect()
                            }
                            else {
                                self.connector.setDisconnect()
                            }
                        }
                    } label: {
                        Text(isServerFind ? (isServerConnect ? "Disconnection" : "Connection") : "Server Search" )
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 350, height: 40)
                            .background(isServerFind ? (isServerConnect ? Color("ScanStopColor") : Color("ScanStartColor")) : Color("ScanWaitColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                            .padding(5)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // Home Settings
                Section(header: Text("Home").bold()) {
                    // Home Setup
                    HStack {
                        HStack {
                            Image(systemName: "house")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Home Setup")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isHomeSetupView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isHomeSetupView) {
                                HomeSetupView(connector: self.$connector, viewController: $isHomeSetupView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                    // Option Update
                    HStack {
                        HStack {
                            Image(systemName: "gear")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrow.up.arrow.down.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Option Update")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isOptionUpdateView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isOptionUpdateView) {
                                OptionUpdateView(connector: self.$connector, viewController: $isOptionUpdateView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                }
                
                // User Settings
                Section(header: Text("User").bold()) {
                    // User setup
                    HStack {
                        HStack {
                            Image(systemName: "person")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("User Setup")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isUserSetupView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isUserSetupView) {
                                UserSetupView(connector: self.$connector, viewController: $isUserSetupView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                }
                
                // Device Settings
                Section(header: Text("Device").bold()) {
                    // Device setup
                    HStack {
                        HStack {
                            Image(systemName: "ipad.and.iphone")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Device Setup")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isDeviceSetupView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isDeviceSetupView) {
                                DeviceSetupView(connector: self.$connector, viewController: $isDeviceSetupView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                }
                
                // Space Settings
                Section(header: Text("Space").bold()) {
                    // Space Register
                    HStack {
                        HStack {
                            Image(systemName: "square.on.square.intersection.dashed")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "plus.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Space Register")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isSpaceRegisterView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isSpaceRegisterView) {
                                SpaceRegisterView(connector: self.$connector, viewController: $isSpaceRegisterView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                    
                    // Space Setup
                    HStack {
                        HStack {
                            Image(systemName: "square.on.square")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Space Setup")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isSpaceSetupView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isSpaceSetupView) {
                                SpaceSetupView(connector: self.$connector, viewController: $isSpaceSetupView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                }
                
                // Beacon Settings
                Section(header: Text("Beacon").bold()) {
                    // Beacon Register
                    HStack {
                        HStack {
                            Image(systemName: "sensor.tag.radiowaves.forward")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "plus.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Beacon Register")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isBeaconRegisterView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isBeaconRegisterView) {
                                BeaconRegisterView(connector: self.$connector, viewController: $isBeaconRegisterView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                    
                    // Beacon Update
                    HStack {
                        HStack {
                            Image(systemName: "sensor.tag.radiowaves.forward")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrow.up.arrow.down.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Beacon Update")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isBeaconUpdateView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isBeaconUpdateView) {
                                BeaconUpdateView(connector: self.$connector, viewController: $isBeaconUpdateView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                    
                    // Beacon Power Update
                    HStack {
                        HStack {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "arrow.up.arrow.down.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Beacon Power Update")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isBeaconPowerUpdateView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isBeaconPowerUpdateView) {
                                BeaconPowerUpdateView(connector: self.$connector, viewController: $isBeaconPowerUpdateView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                    
                    // Primary Beacon Setup
                    HStack {
                        HStack {
                            Image(systemName: "airplayaudio")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .frame(width: 50, height: 50)
                            Image(systemName: "checkmark.square")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("BeaconDefaultColor"))
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        HStack {
                            Text("Primary Beacon Setup")
                                .font(.custom("SamsungOneKorean-700", size: 20))
                                .frame(width: 250, alignment: .leading)
                                .padding(.bottom, 1)
                            Button {
                                isPrimaryBeaconSetupView.toggle()
                            } label: {
                                Text(">")
                                    .font(.custom("SamsungOneKorean-600", size: 17))
                                    .frame(width: 15, alignment: .trailing)
                                    .foregroundColor(Color("BeaconDefaultColor"))
                            }
                            .sheet(isPresented: $isPrimaryBeaconSetupView) {
                                PrimaryBeaconSetupView(connector: self.$connector, viewController: $isPrimaryBeaconSetupView)
                            }
                            .disabled(!isServerConnect)
                        }
                    }
                }
            }
        }
        .navigationTitle("Data Transfer")
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim")))
        }
    }
}

struct HomeSetupView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseValues: [String : Any] = [:]
    @State private var homeName: String = ""
    @State private var intervalTime: Int = 60
    @State private var expireCount: Int = 5
    
    @State private var isAlreadyHome: Bool = false
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        ScrollView {
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
                        .disabled(isAlreadyHome)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                .padding(5)
                
                Button {
                    hideKeyboard()
                    
                    if self.isAlreadyHome {
                        UserDefaults.standard.setValue(self.homeName, forKey: "homeName")
                        UserDefaults.standard.setValue(self.intervalTime, forKey: "intervalTime")
                        UserDefaults.standard.setValue(self.expireCount, forKey: "expireCount")
                        
                        viewController.toggle()
                    }
                    else {
                        Task {
                            self.responseValues = try await self.connector.homeRegister(homeName: self.homeName)
                            let isSuccess: Bool = responseValues["valid"] as! Bool
                            
                            if isSuccess {
                                UserDefaults.standard.setValue(responseValues["home_name"] as! String, forKey: "homeName")
                                UserDefaults.standard.setValue(responseValues["interval_time"] as! Int, forKey: "intervalTime")
                                UserDefaults.standard.setValue(responseValues["expire_count"] as! Int, forKey: "expireCount")
                                
                                viewController.toggle()
                            }
                            else {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                        }
                    }
                } label: {
                    Text(isAlreadyHome ? "Start" : "Set the home name and Start")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(isAlreadyHome ? Color("BeaconNormalColor") : Color("BeaconTriggeredColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            Task {
                self.responseValues = try await self.connector.homeCheck()
                self.isAlreadyHome = responseValues["valid"] as! Bool
                
                if self.isAlreadyHome {
                    self.homeName = responseValues["home_name"] as! String
                    self.intervalTime = responseValues["interval_time"] as! Int
                    self.expireCount = responseValues["expire_count"] as! Int
                }
            }
        }
    }
}

struct OptionUpdateView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseValues: [String : Any] = [:]
    @State private var homeName: String = ""
    @State private var intervalTime: Int = 60
    @State private var expireCount: Int = 5
    
    @State private var isAlreadyHome: Bool = false
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "gear")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Server Options")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        ScrollView {
            HStack {
                Text("Interval Time")
                    .frame(width: 120, alignment: .leading)
                    .foregroundColor(.gray)
                    .bold()
                Divider()
                TextField("Natural Number", value:$intervalTime, format:.number)
                    .frame(width: 200, alignment: .leading)
                    .disabled(!isAlreadyHome)
            }
            .frame(width: 400, height: 40)
            .background(Color("BackgroundColor"))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .padding(5)
            
            HStack {
                Text("Expired Count")
                    .frame(width: 120, alignment: .leading)
                    .foregroundColor(.gray)
                    .bold()
                Divider()
                TextField("Natural Number", value:$expireCount, format:.number)
                    .frame(width: 200, alignment: .leading)
                    .disabled(!isAlreadyHome)
            }
            .frame(width: 400, height: 40)
            .background(Color("BackgroundColor"))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .padding(5)
            
            Button {
                hideKeyboard()
                
                Task {
                    self.responseValues = try await self.connector.settingUpdate(homeName: self.homeName, intervalTime: self.intervalTime, expireCount: self.expireCount)
                    let isSuccess: Bool = responseValues["valid"] as! Bool
                    
                    if isSuccess {
                        UserDefaults.standard.setValue(self.intervalTime, forKey: "intervalTime")
                        UserDefaults.standard.setValue(self.expireCount, forKey: "expireCount")
                        viewController.toggle()
                    }
                    else {
                        self.message = responseValues["msg"] as! String
                        isError.toggle()
                    }
                }
            } label: {
                Text(isAlreadyHome ? "Update" : "Error")
                    .font(.custom("SamsungOneKorean-700", size: 18))
                    .frame(width: 400, height: 40)
                    .background(isAlreadyHome ? Color("BeaconNormalColor") : Color("BeaconDefaultColor"))
                    .foregroundColor(Color("BackgroundColor"))
                    .cornerRadius(20)
            }
            .disabled(!isAlreadyHome)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            Task {
                self.responseValues = try await self.connector.homeCheck()
                self.isAlreadyHome = responseValues["valid"] as! Bool
                
                if self.isAlreadyHome {
                    self.homeName = responseValues["home_name"] as! String
                    self.intervalTime = responseValues["interval_time"] as! Int
                    self.expireCount = responseValues["expire_count"] as! Int
                }
                else {
                    self.message = responseValues["msg"] as! String
                    isError.toggle()
                }
            }
        }
    }
}

struct UserList {
    var familiarName: String
    var id: String
}

struct UserSetupView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseList: [[String : Any]] = []
    @State private var responseValues: [String : Any] = [:]
    @State private var userName: String = ""
    @State private var userID: String = ""
    @State private var newUserName: String = ""
    @State private var userList: [UserList] = []
    
    @State private var isEmpty: Bool = true
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "person.3")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("User Setup")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        // New User Part
        Text("New User")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        HStack {
            Text("User Name")
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.gray)
                .bold()
            Divider()
            TextField("User Identification Name", text:$newUserName)
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
            hideKeyboard()
            
            Task {
                self.responseValues = try await self.connector.userRegister(userName: self.newUserName)
                let isSuccess: Bool = self.responseValues["valid"] as! Bool
                
                if !isSuccess {
                    self.message = responseValues["msg"] as! String
                    isError.toggle()
                }
                
                self.userList = []
                self.responseList = try await self.connector.userRequest()
                self.isEmpty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmpty {
                    for userData: [String : Any] in responseList {
                        let userName: String = userData["user_name"] as! String
                        let userID: String = userData["id"] as! String
                        self.userList.append(UserList(familiarName: userName, id: userID))
                    }
                }
            }
        } label: {
            Text("Add User")
                .font(.custom("SamsungOneKorean-700", size: 18))
                .frame(width: 400, height: 40)
                .background(Color("BluetoothColor"))
                .foregroundColor(Color("BackgroundColor"))
                .cornerRadius(20)
                .padding(5)
        }
        
        Divider()
            .frame(height: 5)
        
        // Already exist User Part
        Text("User List")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        if isEmpty {
            Text("Empty")
                .font(.custom("SamsungOneKorean-700", size: 25))
                .foregroundColor(.gray)
                .frame(width: 380, height: 50, alignment: .center)
                .bold()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
        }
        
        List(userList, id: \.id) { userData in
            VStack {
                HStack {
                    Image(systemName: "person")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BeaconDefaultColor"))
                    Text("\(userData.familiarName)")
                        .font(.custom("SamsungOneKorean-700", size: 25))
                        .frame(width: 300, alignment: .leading)
                        .bold()
                }
                
                Text("\(userData.id)")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .frame(width: 250, alignment: .leading)
                    .bold()
                HStack {
                    Button {
                        self.userName = userData.familiarName
                        self.userID = userData.id
                        
                        UserDefaults.standard.setValue(true, forKey: "isUserSet")
                        UserDefaults.standard.setValue(self.userName, forKey: "userName")
                        UserDefaults.standard.setValue(self.userID, forKey: "userID")
                        
                        UserDefaults.standard.setValue(false, forKey: "isDeviceSet")
                        UserDefaults.standard.setValue("", forKey: "deviceName")
                        UserDefaults.standard.setValue("", forKey: "deviceID")
                        
                        viewController.toggle()
                    } label: {
                        Text("Select")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 220, height: 40)
                            .background(Color("BeaconNormalColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Button {
                        Task {
                            self.responseValues = try await self.connector.userDelete(userID: userData.id)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if !isSuccess {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                            
                            self.userList = []
                            self.responseList = try await self.connector.userRequest()
                            self.isEmpty = !(responseList[0]["valid"] as! Bool)
                            
                            if !isEmpty {
                                for userData: [String : Any] in responseList {
                                    let userName: String = userData["user_name"] as! String
                                    let userID: String = userData["id"] as! String
                                    self.userList.append(UserList(familiarName: userName, id: userID))
                                }
                            }
                        }
                    } label: {
                        Text("Delete")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 110, height: 40)
                            .background(Color("BeaconLowBatteryColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(width: 400, height: 140)
            .background(Color("BackgroundColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .listRowSeparator(.hidden)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            Task {
                self.userList = []
                self.responseList = try await self.connector.userRequest()
                self.isEmpty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmpty {
                    for userData: [String : Any] in responseList {
                        let userName: String = userData["user_name"] as! String
                        let userID: String = userData["id"] as! String
                        self.userList.append(UserList(familiarName: userName, id: userID))
                    }
                }
            }
        }
    }
}

struct DeviceList {
    var familiarName: String
    var id: String
}

struct DeviceSetupView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseList: [[String : Any]] = []
    @State private var responseValues: [String : Any] = [:]
    @State private var isUserSet: Bool = false
    @State private var userName: String = ""
    @State private var userID: String = ""
    @State private var newDeviceName: String = ""
    @State private var deviceName: String = ""
    @State private var deviceID: String = ""
    @State private var deviceList: [DeviceList] = []
    
    @State private var isEmpty: Bool = true
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "ipad.and.iphone")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Device Setup")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        // New Device Part
        Text("New Device")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        HStack {
            Text("User Name")
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.gray)
                .bold()
            Divider()
            Text("\(userName)")
                .frame(width: 200, alignment: .leading)
        }
        .frame(width: 400, height: 40)
        .background(Color("BackgroundColor"))
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color("OutlineColor"), lineWidth: 2)
        )
        .padding(5)
        
        HStack {
            Text("Device Name")
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.gray)
                .bold()
            Divider()
            TextField("Identification Name", text:$newDeviceName)
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
            hideKeyboard()
            
            Task {
                Task {
                    self.responseValues = try await self.connector.deviceNewRegister(deviceName: newDeviceName, userID: userID)
                    let isSuccess: Bool = self.responseValues["valid"] as! Bool
                    
                    if !isSuccess {
                        self.message = responseValues["msg"] as! String
                        isError.toggle()
                    }
                    
                    self.deviceList = []
                    self.responseList = try await self.connector.deviceMyRequest(userID: self.userID)
                    self.isEmpty = !(responseList[0]["valid"] as! Bool)
                    
                    if !isEmpty {
                        for deviceData: [String : Any] in responseList {
                            let deviceName: String = deviceData["familiar_name"] as! String
                            let deviceID: String = deviceData["id"] as! String
                            self.deviceList.append(DeviceList(familiarName: deviceName, id: deviceID))
                        }
                    }
                }
            }
        } label: {
            Text("Add Device")
                .font(.custom("SamsungOneKorean-700", size: 18))
                .frame(width: 400, height: 40)
                .background(Color("BluetoothColor"))
                .foregroundColor(Color("BackgroundColor"))
                .cornerRadius(20)
                .padding(5)
        }
        
        Divider()
            .frame(height: 5)
        
        // Already exist Device Part
        Text("Device List")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        if isEmpty {
            Text("Empty")
                .font(.custom("SamsungOneKorean-700", size: 25))
                .foregroundColor(.gray)
                .frame(width: 380, height: 50, alignment: .center)
                .bold()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
        }
        
        List(deviceList, id: \.id) { deviceData in
            VStack {
                HStack {
                    Image(systemName: "iphone.gen2")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BeaconDefaultColor"))
                    Text("\(deviceData.familiarName)")
                        .font(.custom("SamsungOneKorean-700", size: 25))
                        .frame(width: 300, alignment: .leading)
                        .bold()
                }
                
                Text("\(deviceData.id)")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .frame(width: 250, alignment: .leading)
                    .bold()
                HStack {
                    Button {
                        self.deviceName = deviceData.familiarName
                        self.deviceID = deviceData.id
                        
                        UserDefaults.standard.setValue(true, forKey: "isDeviceSet")
                        UserDefaults.standard.setValue(self.deviceName, forKey: "deviceName")
                        UserDefaults.standard.setValue(self.deviceID, forKey: "deviceID")
                        
                        viewController.toggle()
                    } label: {
                        Text("Select")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 220, height: 40)
                            .background(Color("BeaconNormalColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Button {
                        Task {
                            self.responseValues = try await self.connector.deviceDelete(deviceID: deviceData.id)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if !isSuccess {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                            
                            self.deviceList = []
                            self.responseList = try await self.connector.deviceMyRequest(userID: self.userID)
                            self.isEmpty = !(responseList[0]["valid"] as! Bool)
                            
                            if !isEmpty {
                                for deviceData: [String : Any] in responseList {
                                    let deviceName: String = deviceData["familiar_name"] as! String
                                    let deviceID: String = deviceData["id"] as! String
                                    self.deviceList.append(DeviceList(familiarName: deviceName, id: deviceID))
                                }
                            }
                        }
                    } label: {
                        Text("Delete")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 110, height: 40)
                            .background(Color("BeaconLowBatteryColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(width: 400, height: 140)
            .background(Color("BackgroundColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .listRowSeparator(.hidden)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            self.isUserSet = UserDefaults.standard.value(forKey: "isUserSet") as? Bool ?? false
            
            if !isUserSet {
                self.message = "Please set up the user first and run the device settings"
                isError.toggle()
            }
            else {
                self.userName = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
                self.userID = UserDefaults.standard.value(forKey: "userID") as? String ?? ""
                
                Task {
                    self.deviceList = []
                    self.responseList = try await self.connector.deviceMyRequest(userID: self.userID)
                    self.isEmpty = !(responseList[0]["valid"] as! Bool)
                    
                    if !isEmpty {
                        for deviceData: [String : Any] in responseList {
                            let deviceName: String = deviceData["familiar_name"] as! String
                            let deviceID: String = deviceData["id"] as! String
                            self.deviceList.append(DeviceList(familiarName: deviceName, id: deviceID))
                        }
                    }
                }
            }
        }
    }
}

struct SpaceRegisterView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseValues: [String : Any] = [:]
    @State private var spaceName: String = ""
    @State private var sizeX: Float = 0.0
    @State private var sizeY: Float = 0.0
    
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "square.on.square.intersection.dashed")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Space Register")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:100)
        
        ScrollView {
            VStack {
                Image("RoomImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .offset(x: 20)
                    .padding(.bottom, 30.0)
                
                HStack{
                    Text("Space Name")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    TextField("Identification Name", text:$spaceName)
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                .padding(5)
                
                HStack{
                    Text("Size X (m)")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    TextField("Float Number (meter)", value:$sizeX, format:.number)
                        .frame(width: 200, alignment: .leading)
                        .keyboardType(.decimalPad)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                .padding(5)
                
                HStack{
                    Text("Size Y (m)")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    TextField("Float Number (meter)", value:$sizeY, format:.number)
                        .frame(width: 200, alignment: .leading)
                        .keyboardType(.decimalPad)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                .padding(5)
                
                Button {
                    hideKeyboard()
                    
                    Task {
                        self.responseValues = try await self.connector.spaceRegister(spaceName: spaceName, sizeX: sizeX, sizeY: sizeY)
                        let isSuccess: Bool = responseValues["valid"] as! Bool
                        
                        if isSuccess {
                            UserDefaults.standard.setValue(true, forKey: "isSpaceSet")
                            UserDefaults.standard.setValue(responseValues["id"] as! String, forKey: "spaceID")
                            
                            viewController.toggle()
                        }
                        else {
                            self.message = responseValues["msg"] as! String
                            isError.toggle()
                        }
                    }
                } label: {
                    Text("Add Space")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(Color("BluetoothColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
    }
}

struct SpaceList {
    var familiarName: String
    var id: String
    var sizeX: Float
    var sizeY: Float
}

struct SpaceSetupView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseList: [[String : Any]] = []
    @State private var responseValues: [String : Any] = [:]
    @State private var isSpaceSet: Bool = false
    @State private var spaceID: String = ""
    @State private var spaceList: [SpaceList] = []
    
    @State private var isEmpty: Bool = true
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "square.on.square")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Space Setup")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        // Space List Part
        Text("Space List")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        if isEmpty {
            Text("Empty")
                .font(.custom("SamsungOneKorean-700", size: 25))
                .foregroundColor(.gray)
                .frame(width: 380, height: 50, alignment: .center)
                .bold()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
        }
        
        List(spaceList, id: \.id) { spaceData in
            VStack {
                HStack {
                    Image(systemName: "rectangle.on.rectangle.square.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BeaconDefaultColor"))
                    Text("\(spaceData.familiarName)")
                        .font(.custom("SamsungOneKorean-700", size: 25))
                        .frame(width: 300, alignment: .leading)
                        .bold()
                }
                
                Text("\(spaceData.id)")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .frame(width: 250, alignment: .leading)
                    .bold()
                Text("Size X : \(String(format: "%.2f", spaceData.sizeX))m, Size Y : \(String(format: "%.2f", spaceData.sizeY))m")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .frame(width: 250, alignment: .leading)
                
                HStack {
                    Button {
                        self.spaceID = spaceData.id
                        
                        UserDefaults.standard.setValue(true, forKey: "isSpaceSet")
                        UserDefaults.standard.setValue(self.spaceID, forKey: "spaceID")
                        
                        viewController.toggle()
                    } label: {
                        Text("Select")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 220, height: 40)
                            .background(Color("BeaconNormalColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Button {
                        Task {
                            self.responseValues = try await self.connector.spaceDelete(spaceID: spaceData.id)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if !isSuccess {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                            
                            self.spaceList = []
                            self.responseList = try await self.connector.spaceRequest()
                            self.isEmpty = !(responseList[0]["valid"] as! Bool)
                            
                            if !isEmpty {
                                for spaceData: [String : Any] in responseList {
                                    let spaceName: String = spaceData["familiar_name"] as! String
                                    let spaceID: String = spaceData["id"] as! String
                                    let sizeX: Float = (spaceData["size_x"] as! NSNumber).floatValue
                                    let sizeY: Float = (spaceData["size_y"] as! NSNumber).floatValue
                                    self.spaceList.append(SpaceList(familiarName: spaceName, id: spaceID, sizeX: sizeX, sizeY: sizeY))
                                }
                            }
                        }
                    } label: {
                        Text("Delete")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 110, height: 40)
                            .background(Color("BeaconLowBatteryColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(width: 400, height: 160)
            .background(Color("BackgroundColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .listRowSeparator(.hidden)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            Task {
                self.spaceList = []
                self.responseList = try await self.connector.spaceRequest()
                self.isEmpty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmpty {
                    for spaceData: [String : Any] in responseList {
                        let spaceName: String = spaceData["familiar_name"] as! String
                        let spaceID: String = spaceData["id"] as! String
                        let sizeX: Float = (spaceData["size_x"] as! NSNumber).floatValue
                        let sizeY: Float = (spaceData["size_y"] as! NSNumber).floatValue
                        self.spaceList.append(SpaceList(familiarName: spaceName, id: spaceID, sizeX: sizeX, sizeY: sizeY))
                    }
                }
            }
        }
    }
}

struct BeaconRegisterView: View, BeaconScannerDelegate {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State var beaconScanner: BeaconScanner!
    @State private var searchID: String = ""
    @State private var time: Int = 60
    
    @State private var responseValues: [String : Any] = [:]
    @State private var isSpaceSet: Bool = false
    @State private var spaceID: String = ""
    @State private var beaconID: String = ""
    @State private var beaconState: String = ""
    @State private var beaconStateHex: String = ""
    @State private var beaconPower: Int = -62
    @State private var beaconPrimary: Bool = false
    @State private var posX: Float = 0.0
    @State private var posY: Float = 0.0
    
    @State private var isScanning: Bool = false
    @State private var isFilled: Bool = false
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _namespaceID = beaconInfo.beaconID?.idtostring(idType: .Namespace) ?? "17FD1CEFFF705E7F803E"
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "FFFFFFFFFFFF"
        let _state = beaconInfo.beaconState?.deviceState
        let _stateHex = beaconInfo.beaconState?.deviceStateHex
        let _batteryLevel = beaconInfo.beaconState?.batteryAmout ?? 0
        let _txPower = beaconInfo.txPower
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
        
        if _namespaceID == self.searchID && _state == .Triggered  {
            self.beaconID = _instanceID
            self.beaconState = "\(stateString) [Battery :\(_batteryLevel)%]"
            self.beaconStateHex = _stateHex ?? "FFFF"
            self.beaconPower = _txPower
            
            self.isFilled = true
            self.isScanning = false
            self.beaconScanner.stopScanning()
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Beacon Register")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:100)
        
        ScrollView {
            VStack {
                Image("BeaconSetImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 350)
                    .offset(x: 0)
                    .padding(.bottom, 30.0)
                
                // Find Data
                HStack{
                    Text("SpaceID")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(spaceID)")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("Beacon ID")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(beaconID)")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("Beacon State")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(beaconState)")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                Button {
                    isScanning.toggle()
                    if isScanning {
                        self.beaconScanner.startScanning()
                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(time)) {
                            self.isScanning = false
                            self.beaconScanner.stopScanning()
                        }
                    }
                    else {
                        self.beaconScanner.stopScanning()
                        
                        self.beaconID = ""
                        self.beaconState = ""
                        self.beaconStateHex = ""
                        self.beaconPower = -62
                        self.isFilled = false
                    }
                } label: {
                    Text(isScanning ? "Stop Scan" : "Scan Beacon")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(isScanning ? Color("BeaconLowBatteryColor") : Color("BeaconNormalColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                        .padding(5)
                }
                
                // Input Data
                HStack{
                    Text("Primary Beacon")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Toggle("", isOn: $beaconPrimary)
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("Position X (m)")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    TextField("Float Value (meter)", value: $posX, format: .number)
                        .frame(width: 200, alignment: .leading)
                        .keyboardType(.decimalPad)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("Position Y (m)")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    TextField("Float Value (meter)", value: $posY, format: .number)
                        .frame(width: 200, alignment: .leading)
                        .keyboardType(.decimalPad)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                Button {
                    if isFilled {
                        Task {
                            self.responseValues = try await self.connector.beaconRegister(beaconID: self.beaconID, state: self.beaconStateHex, spaceID: self.spaceID, posX: self.posX, posY: self.posY, power: beaconPower, isPrimary: beaconPrimary)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if isSuccess {
                                viewController.toggle()
                            }
                            else {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                        }
                    }
                    else {
                        self.message = "Please try to register after Beacon Scan"
                        isError.toggle()
                    }
                } label: {
                    Text("Add Beacon")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(Color("BluetoothColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                        .padding(5)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            self.isSpaceSet = UserDefaults.standard.value(forKey: "isSpaceSet") as? Bool ?? false
            if !isSpaceSet {
                self.message = "Please set up the space first and run the beacon settings"
                isError.toggle()
            }
            else {
                self.beaconScanner = BeaconScanner()
                self.beaconScanner.delegate = self
                self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17FD1CEFFF705E7F803E"
                self.time = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
                
                self.spaceID = UserDefaults.standard.value(forKey: "spaceID") as? String ?? ""
            }
        }
        .onDisappear {
            if isScanning {
                self.beaconScanner.stopScanning()
                self.isScanning = false
            }
        }
    }
}

struct BeaconList {
    var id: String
    var stateHex: String
    var spaceID: String
    var posX: Float
    var posY: Float
    var power: Int
    var isPrimary: Bool
}

struct BeaconUpdateView: View {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State private var responseList: [[String : Any]] = []
    @State private var responseValues: [String : Any] = [:]
    @State private var beaconList: [BeaconList] = [BeaconList(id: "FFFFFFFFFFFF", stateHex: "FFFF", spaceID: "FFFFFFFFFFFF", posX: 10.3, posY: 10.3, power: -62, isPrimary: true)]
    
    @State private var isEmpty: Bool = false
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    var body: some View {
        HStack {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Beacon Update")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        // Beacon List Part
        Text("Beacon List")
            .font(.custom("SamsungOneKorean-700", size: 20))
            .foregroundColor(.gray)
            .frame(width: 350, alignment: .leading)
            .bold()
        
        if isEmpty {
            Text("Empty")
                .font(.custom("SamsungOneKorean-700", size: 25))
                .foregroundColor(.gray)
                .frame(width: 400, height: 50, alignment: .center)
                .bold()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
        }
        
        List(beaconList, id: \.id) { beaconData in
            VStack {
                HStack {
                    Image(systemName: beaconData.isPrimary ? "sensor.tag.radiowaves.forward.fill" : "sensor.tag.radiowaves.forward")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BeaconDefaultColor"))
                    Text("\(beaconData.id) \(beaconData.isPrimary ? "[Primary]" : "")")
                        .font(.custom("SamsungOneKorean-700", size: 25))
                        .frame(width: 300, alignment: .leading)
                        .bold()
                }
                
                Text("Space ID : \(beaconData.spaceID)")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 26)
                    .frame(width: 300, alignment: .leading)
                    .bold()
                Text("Position X : \(String(format: "%.2f", beaconData.posX))m, Position Y : \(String(format: "%.2f", beaconData.posY))m")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 26)
                    .frame(width: 300, alignment: .leading)
                Text("State : \(beaconData.stateHex), Power : \(beaconData.power)dBm")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 26)
                    .frame(width: 300, alignment: .leading)
                
                HStack {
                    Button {
                        Task {
                            self.responseValues = try await self.connector.beaconDelete(beaconID: beaconData.id)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if !isSuccess {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                            
                            self.beaconList = []
                            self.responseList = try await self.connector.beaconAllRequest()
                            self.isEmpty = !(responseList[0]["valid"] as! Bool)
                            
                            if !isEmpty {
                                for beaconData: [String : Any] in responseList {
                                    let id: String = beaconData["id"] as! String
                                    let stateHex: String = beaconData["state"] as! String
                                    let spaceID: String = beaconData["space_id"] as! String
                                    let posX: Float = beaconData["pos_x"] as! Float
                                    let posY: Float = beaconData["pos_y"] as! Float
                                    let power: Int = beaconData["power"] as! Int
                                    let isPrimary: Bool = beaconData["isprimary"] as! Bool
                                    
                                    self.beaconList.append(BeaconList(id: id, stateHex: stateHex, spaceID: spaceID, posX: posX, posY: posY, power: power, isPrimary: isPrimary))
                                }
                            }
                        }
                    } label: {
                        Text("Delete")
                            .font(.custom("SamsungOneKorean-700", size: 18))
                            .frame(width: 200, height: 40)
                            .background(Color("BeaconLowBatteryColor"))
                            .foregroundColor(Color("BackgroundColor"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(width: 400, height: 170)
            .background(Color("BackgroundColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .listRowSeparator(.hidden)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            Task {
                self.beaconList = []
                self.responseList = try await self.connector.beaconAllRequest()
                self.isEmpty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmpty {
                    for beaconData: [String : Any] in responseList {
                        let id: String = beaconData["id"] as! String
                        let stateHex: String = beaconData["state"] as! String
                        let spaceID: String = beaconData["space_id"] as! String
                        let posX: Float = (beaconData["pos_x"] as! NSNumber).floatValue
                        let posY: Float = (beaconData["pos_y"] as! NSNumber).floatValue
                        let power: Int = beaconData["power"] as! Int
                        let isPrimary: Bool = beaconData["isprimary"] as! Bool
                        
                        self.beaconList.append(BeaconList(id: id, stateHex: stateHex, spaceID: spaceID, posX: posX, posY: posY, power: power, isPrimary: isPrimary))
                    }
                }
            }
        }
    }
}

struct BeaconPowerUpdateView: View, BeaconScannerDelegate {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State var beaconScanner: BeaconScanner!
    @State private var searchID: String = ""
    @State private var noRSSI: Int = 10
    @State private var time: Int = 60
    
    @State private var responseValues: [String : Any] = [:]
    @State private var beaconID: String = ""
    @State private var beaconState: String = ""
    @State private var beaconStateHex: String = ""
    @State private var beaconPower: Int = -62
    @State private var beaconRssi: [Int] = []
    
    @State private var isScanning: Bool = false
    @State private var isFilled: Bool = false
    @State private var isError: Bool = false
    
    @State private var message: String = "Unknown"
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _namespaceID = beaconInfo.beaconID?.idtostring(idType: .Namespace) ?? "17FD1CEFFF705E7F803E"
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "FFFFFFFFFFFF"
        let _state = beaconInfo.beaconState?.deviceState
        let _stateHex = beaconInfo.beaconState?.deviceStateHex
        let _batteryLevel = beaconInfo.beaconState?.batteryAmout ?? 0
        let _rssi = (beaconInfo.RSSI < -120 || beaconInfo.RSSI > 0) ? -120 : beaconInfo.RSSI
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
        
        if _namespaceID == self.searchID && _state == .Triggered {
            if self.beaconRssi.count == 0 {
                self.beaconID = _instanceID
                self.beaconState = "\(stateString) [Battery :\(_batteryLevel)%]"
                self.beaconStateHex = _stateHex ?? "FFFF"
                self.beaconRssi.append(_rssi)
            }
            else if self.beaconRssi.count > 0 && self.beaconRssi.count < self.noRSSI {
                if _instanceID == self.beaconID {
                    self.beaconRssi.append(_rssi)
                }
            }
            else {
                self.isFilled = true
                self.isScanning = false
                self.beaconScanner.stopScanning()
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Beacon Power Update")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:100)
        
        ScrollView {
            VStack {
                Image("BeaconSetImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 350)
                    .offset(x: 0)
                    .padding(.bottom, 30.0)
                
                HStack{
                    Text("Beacon ID")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(beaconID)")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("Beacon State")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(beaconState)")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                HStack{
                    Text("RSSI")
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    Divider()
                    Text("\(beaconRssi.map(String.init).joined(separator: " "))")
                        .frame(width: 200, alignment: .leading)
                }
                .frame(width: 400, height: 40)
                .background(Color("BackgroundColor"))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
                
                Button {
                    isScanning.toggle()
                    if isScanning {
                        self.beaconScanner.startScanning()
                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(time)) {
                            self.isScanning = false
                            self.beaconScanner.stopScanning()
                        }
                    }
                    else {
                        self.beaconScanner.stopScanning()
                        
                        self.beaconID = ""
                        self.beaconState = ""
                        self.beaconStateHex = ""
                        self.beaconRssi = []
                        self.isFilled = false
                    }
                } label: {
                    Text(isScanning ? "Stop Scan" : "Scan Beacon")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(isScanning ? Color("BeaconLowBatteryColor") : Color("BeaconNormalColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                        .padding(5)
                }
                
                Button {
                    if isFilled {
                        Task {
                            self.responseValues = try await self.connector.beaconPowerUpdate(beaconID: self.beaconID, state: self.beaconStateHex, rssiData: self.beaconRssi)
                            let isSuccess: Bool = self.responseValues["valid"] as! Bool
                            
                            if isSuccess {
                                viewController.toggle()
                            }
                            else {
                                self.message = responseValues["msg"] as! String
                                isError.toggle()
                            }
                        }
                    }
                    else {
                        self.message = "Please try to register after Beacon Scan"
                        isError.toggle()
                    }
                } label: {
                    Text("Update Power Data")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 400, height: 40)
                        .background(Color("BluetoothColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(20)
                        .padding(5)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            self.beaconScanner = BeaconScanner()
            self.beaconScanner.delegate = self
            
            self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17FD1CEFFF705E7F803E"
            self.time = UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60
            self.noRSSI = UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10
        }
        .onDisappear {
            if isScanning {
                self.beaconScanner.stopScanning()
                self.isScanning = false
            }
        }
    }
}

struct PrimaryBeaconList {
    var id: String
    var stateHex: String
    var rssi: [Int]
}

struct PrimaryBeaconSetupView: View, BeaconScannerDelegate {
    @Binding var connector: MainStationConnector!
    @Binding var viewController: Bool
    
    @State var beaconScanner: BeaconScanner!
    @State private var searchID: String = ""
    @State private var noRSSI: Int = 100
    @State private var time: Int = 120
    
    @State private var responseValues: [String : Any] = [:]
    @State private var isSpaceSet: Bool = false
    @State private var spaceID: String = ""
    @State private var responseList: [[String : Any]] = []
    @State private var loadPrimaryList: [String] = []
    @State private var setPrimaryList: [String] = []
    @State private var primaryBeaconList: [PrimaryBeaconList] = []
    
    @State private var isError: Bool = false
    @State private var isScanning: Bool = false
    
    @State private var message: String = "Unknown"
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        let _namespaceID = beaconInfo.beaconID?.idtostring(idType: .Namespace) ?? "17FD1CEFFF705E7F803E"
        let _instanceID = beaconInfo.beaconID?.idtostring(idType: .Instance) ?? "FFFFFFFFFFFF"
        let _stateHex = beaconInfo.beaconState?.deviceStateHex ?? "FFFF"
        let _rssi = (beaconInfo.RSSI < -120 || beaconInfo.RSSI > 0) ? -120 : beaconInfo.RSSI
        
        let indexID = self.setPrimaryList.firstIndex(of: _instanceID)
        let checkID = self.loadPrimaryList.firstIndex(of: _instanceID)
        
        if (_namespaceID == self.searchID) && (checkID != nil) {
            if indexID != nil {
                if self.primaryBeaconList[indexID!].rssi.count < self.noRSSI {
                    self.primaryBeaconList[indexID!].rssi.append(_rssi)
                }
            }
            else {
                self.setPrimaryList.append(_instanceID)
                self.primaryBeaconList.append(PrimaryBeaconList(id: _instanceID, stateHex: _stateHex, rssi: [_rssi]))
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "airplayaudio")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("BeaconDefaultColor"))
            Text("Primary Beacon Setup")
                .font(.custom("SamsungOneKorean-700", size: 32))
                .frame(alignment: .leading)
        }
        .frame(width:400, height:200)
        
        HStack{
            Text("SpaceID")
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.gray)
                .bold()
            Divider()
            Text("\(spaceID)")
                .frame(width: 200, alignment: .leading)
        }
        .frame(width: 400, height: 40)
        .background(Color("BackgroundColor"))
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color("OutlineColor"), lineWidth: 2)
        )
        
        Button {
            isScanning.toggle()
            if isScanning {
                self.beaconScanner.startScanning()
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(time)) {
                    self.isScanning = false
                    self.beaconScanner.stopScanning()
                }
            }
            else {
                self.beaconScanner.stopScanning()
                
                self.setPrimaryList = []
                self.primaryBeaconList = []
            }
        } label: {
            Text(isScanning ? "Stop Scan" : "Scan Beacon")
                .font(.custom("SamsungOneKorean-700", size: 18))
                .frame(width: 400, height: 40)
                .background(isScanning ? Color("BeaconLowBatteryColor") : Color("BeaconNormalColor"))
                .foregroundColor(Color("BackgroundColor"))
                .cornerRadius(20)
                .padding(5)
        }
        
        Button {
            Task {
                var beaconRssiData: [[String : Any]] = []
                
                for primaryBeaconData in self.primaryBeaconList {
                    beaconRssiData.append(["id": primaryBeaconData.id, "state": primaryBeaconData.stateHex, "rssi": primaryBeaconData.rssi])
                }
                self.responseValues = try await self.connector.primaryBeaconRegister(spaceID: self.spaceID, beaconRssiData: beaconRssiData)
                let isSuccess: Bool = self.responseValues["valid"] as! Bool
                
                if isSuccess {
                    viewController.toggle()
                }
                else {
                    self.message = responseValues["msg"] as! String
                    isError.toggle()
                }
            }
        } label: {
            Text(self.primaryBeaconList.isEmpty ? "Unable" : "Primary Beacon Setup")
                .font(.custom("SamsungOneKorean-700", size: 18))
                .frame(width: 400, height: 40)
                .background(self.primaryBeaconList.isEmpty ? Color("BeaconDefaultColor") : Color("BluetoothColor"))
                .foregroundColor(Color("BackgroundColor"))
                .cornerRadius(20)
        }
        .disabled(self.primaryBeaconList.isEmpty)
        
        if self.primaryBeaconList.isEmpty {
            Text("Empty")
                .font(.custom("SamsungOneKorean-700", size: 20))
                .foregroundColor(.gray)
                .frame(width: 400, height: 50, alignment: .center)
                .bold()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("OutlineColor"), lineWidth: 2)
                )
        }
        
        List(primaryBeaconList, id: \.id) { beaconData in
            VStack {
                HStack {
                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("BeaconDefaultColor"))
                    Text("\(beaconData.id)")
                        .font(.custom("SamsungOneKorean-700", size: 25))
                        .frame(width: 300, alignment: .leading)
                        .bold()
                }
                Text("State : \(beaconData.stateHex)")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 26)
                    .frame(width: 300, alignment: .leading)
                Text("RSSI : \(beaconData.rssi.map(String.init).joined(separator: " "))")
                    .font(.custom("SamsungOneKorean-400", size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 26)
                    .frame(width: 300, alignment: .leading)
            }
            .frame(width: 400, height: 100)
            .background(Color("BackgroundColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("OutlineColor"), lineWidth: 2)
            )
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim"), action: { viewController.toggle() }))
        }
        .onAppear {
            self.isSpaceSet = UserDefaults.standard.value(forKey: "isSpaceSet") as? Bool ?? false
            if !isSpaceSet {
                self.message = "Please set up the space first and run the beacon settings"
                isError.toggle()
            }
            else {
                self.beaconScanner = BeaconScanner()
                self.beaconScanner.delegate = self
                self.searchID = UserDefaults.standard.value(forKey: "allBeaconNamespaceID") as? String ?? "17FD1CEFFF705E7F803E"
                self.time = 2 * (UserDefaults.standard.value(forKey: "allBeaconScanTime") as? Int ?? 60)
                self.noRSSI = 10 * (UserDefaults.standard.value(forKey: "allBeaconNoRSSI") as? Int ?? 10)
                
                self.spaceID = UserDefaults.standard.value(forKey: "spaceID") as? String ?? ""
                
                // Primary Beacon Load
                Task {
                    self.responseList = try await self.connector.beaconPriRequest()
                    let isSucess: Bool = self.responseList[0]["valid"] as! Bool
                    
                    if isSucess {
                        for primaryBeaconData: [String : Any] in responseList {
                            self.loadPrimaryList.append(primaryBeaconData["id"] as! String)
                        }
                    }
                    else {
                        self.message = self.responseList[0]["msg"] as! String
                        isError.toggle()
                    }
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
