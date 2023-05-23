//
//  ConnectionTestView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/08.
//

import SwiftUI
import SocketIO

struct ConnectionTestView: View, MainStationFinderDelegate {
    @State var logList: [ConnectionLogListOption] = [ConnectionLogListOption(keyValue: "Waiting", dataValue: "")]
    @State var manager: SocketManager!
    @State var finder: MainStationFinder!
    @State var socket: SocketIOClient!
    @State var isFind: Bool = false
    @State var isConnect: Bool = false
    
    @State private var ipAddress: String = "127.0.0.1"
    @State private var mainPort: String = "8710"
    @State private var udpPort: String = "8711"
    
    func didFindServer(finder: MainStationFinder) {
        self.ipAddress = finder.address
        self.logList.append(ConnectionLogListOption(keyValue: "Find Server", dataValue: finder.address))
        
        self.manager = SocketManager(socketURL: URL(string: "ws://\(ipAddress):\(mainPort)")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket
        self.connectControl()
        self.testResponseMessage()
        
        self.isFind = true
    }
    
    func connectControl() {
        self.socket.on(clientEvent: .connect) {dataArray, socketAck in
            self.logList.append(ConnectionLogListOption(keyValue: "Connected", dataValue: ""))
            NSLog("Connected Server")
            self.requestMessage()
        }
        self.socket.on(clientEvent: .error) {dataArray, socketAck in
            NSLog("Connection Error")
        }
        self.socket.on(clientEvent: .disconnect) {dataArray, socketAck in
            self.logList.append(ConnectionLogListOption(keyValue: "Disconnected", dataValue: ""))
            NSLog("Disconnected Server")
        }

    }
    
    func testResponseMessage() {
        self.socket.on("test_response") { dataArray, socketAck in
            self.logList.append(ConnectionLogListOption(keyValue: "Receive", dataValue: "Test Data from Server"))
            
            let incomeData = dataArray[0] as! NSDictionary
            
            let messageData = incomeData["message"] as! String
            let hexData = incomeData["hex"] as! Int
            let intData = incomeData["int"] as! Int
            let floatCFData = incomeData["float"] as! CFNumber
            
            var floatData: Float = 0
            CFNumberGetValue(floatCFData, .floatType, &floatData)
            
            self.logList.append(ConnectionLogListOption(keyValue: "Message", dataValue: messageData))
            self.logList.append(ConnectionLogListOption(keyValue: "Hex", dataValue: String(hexData, radix: 16, uppercase: true)))
            self.logList.append(ConnectionLogListOption(keyValue: "Int", dataValue: String(intData)))
            self.logList.append(ConnectionLogListOption(keyValue: "Float", dataValue: String(floatData)))
            
            self.testMessage()
        }
    }
    
    func requestMessage() {
        self.socket.emit("test_request")
        self.logList.append(ConnectionLogListOption(keyValue: "Test Request", dataValue: ""))
    }
    
    func testMessage() {
        self.socket.emit("test_send", ["message": "Test from Client",
                                  "hex": 0xAABBCCDDEEFF,
                                  "int": 123456789,
                                  "float": 1.23456789
                                 ] as [String : Any])
        self.logList.append(ConnectionLogListOption(keyValue: "Test Send", dataValue: ""))
    }
    
    var body: some View {
        NavigationStack {
            List(logList, id: \.keyValue) { logListData in
                HStack{
                    Text(logListData.keyValue)
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                    Divider()
                    Text(logListData.dataValue)
                }
            }
        }
        .navigationTitle("Test Connect")
        .toolbar {
            ToolbarItem {
                Button {
                    isConnect.toggle()
                    if isConnect {
                        self.socket.connect()
                    }
                    else {
                        self.socket.disconnect()
                    }
                } label: {
                    Text(isFind ? (isConnect ? "Disconnection" : "Connection") : "Waiting" )
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 130, height: 30)
                        .background(isFind ? (isConnect ? Color("ScanStopColor") : Color("ScanStartColor")) : Color("ScanWaitColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(15)
                }
                .disabled(!isFind)
            }
        }
        .refreshable {
            self.isConnect = false
            self.socket.disconnect()
            self.logList = [ConnectionLogListOption(keyValue: "Waiting", dataValue: "")]
        }
        .onAppear {
            self.mainPort = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
            self.udpPort = UserDefaults.standard.value(forKey: "testConnectionUDPPort") as? String ?? "8711"
            
            self.finder = MainStationFinder(portNumber: self.udpPort)
            self.finder.delegate = self
            self.finder.findStation()
        }
    }
}

struct ConnectionTestView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionTestView()
    }
}
