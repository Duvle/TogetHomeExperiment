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
            // Home Settings
            Section(header: Text("Home").bold()) {
                // Home Setup
                HStack {
                    HStack {
                        Image(systemName: "house")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color("BeaconDefaultColor"))
                            .padding(5)
                        Image(systemName: "plus.square")
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
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(Color("BeaconDefaultColor"))
                            .padding(5)
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
                            .padding(5)
                        Image(systemName: "plus.square")
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
                
            }
            
            // Space Settings
            Section(header: Text("Space").bold()) {
                
            }
            
            // Beacon Settings
            Section(header: Text("Beacon").bold()) {
                
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
            if isServerFind && isServerConnect {
                self.connector.setDisconnect()
            }
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
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim")))
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
        .alert(isPresented: $isError) {
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim")))
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
    
    @State private var isEmprty: Bool = true
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
            Task {
                self.responseValues = try await self.connector.userRegister(userName: self.newUserName)
                let isSuccess: Bool = self.responseValues["valid"] as! Bool
                
                if !isSuccess {
                    self.message = responseValues["msg"] as! String
                    isError.toggle()
                }
                
                self.userList = []
                self.responseList = try await self.connector.userRequest()
                self.isEmprty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmprty {
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
        
        if isEmprty {
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
                        
                        UserDefaults.standard.setValue(self.userName, forKey: "userName")
                        UserDefaults.standard.setValue(self.userID, forKey: "userID")
                        
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
                            self.isEmprty = !(responseList[0]["valid"] as! Bool)
                            
                            if !isEmprty {
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
            .frame(width: 380, height: 140)
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
            Alert(title: Text("Main Station Error"), message: Text(message), dismissButton: .default(Text("Confrim")))
        }
        .onAppear {
            Task {
                self.userList = []
                self.responseList = try await self.connector.userRequest()
                self.isEmprty = !(responseList[0]["valid"] as! Bool)
                
                if !isEmprty {
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

struct ConnectionTransferView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionTransferView()
    }
}
