//
//  ConnectionView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI
import SocketIO

enum ConnectionViewOption {
    case test
    case transfer
    case calculate
}

struct ConnectionListOption {
    var mainTitle: String
    var subTitle: String
    var icon: String
    var targetView: ConnectionViewOption
}

struct ConnectionLogListOption {
    var keyValue: String
    var dataValue: String
}

@ViewBuilder func viewSelect(for viewoption: ConnectionViewOption) -> some View {
    switch viewoption {
    case .test:
        ConnectionTestView()
    case .transfer:
        ConnectionTransferView()
    case .calculate:
        ConnectionCalculateView()
    }
}

struct ConnectionView: View {
    @State var optionList = [
        ConnectionListOption(mainTitle: "Test Connect", subTitle: "Test only pure Socket communication with the Main Station Server.", icon: "captions.bubble", targetView: .test),
        ConnectionListOption(mainTitle: "Data Transfer", subTitle: "Data is exchanged with the Main Station Server.", icon: "server.rack", targetView: .transfer),
        ConnectionListOption(mainTitle: "Position Calculate", subTitle: "Test the Main Station Server and the actual indoor location service.", icon: "location.viewfinder", targetView: .calculate)
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
            }.navigationTitle("Connection")
        }
    }
}

struct ConnectionTestView: View {
    @State var logList: [ConnectionLogListOption] = [ConnectionLogListOption(keyValue: "Waiting", dataValue: "")]
    @State var manager: SocketManager!
    @State var socket: SocketIOClient!
    @State var isConnect: Bool = false
    
    @State private var ipAddress: String = "127.0.0.1"
    @State private var portNumber: String = "8710"
    
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
                    Text(isConnect ? "Disconnection" : "Connection")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 130, height: 30)
                        .background(isConnect ? Color("ScanStopColor") : Color("ScanStartColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(15)
                }
            }
        }
        .refreshable {
            self.isConnect = false
            self.socket.disconnect()
            self.logList = [ConnectionLogListOption(keyValue: "Waiting", dataValue: "")]
        }
        .onAppear {
            self.ipAddress = UserDefaults.standard.value(forKey: "testConnectionIP") as? String ?? "127.0.0.1"
            self.portNumber = UserDefaults.standard.value(forKey: "testConnectionPort") as? String ?? "8710"
            
            self.manager = SocketManager(socketURL: URL(string: "ws://\(ipAddress):\(portNumber)")!, config: [.log(false), .compress])
            self.socket = manager.defaultSocket
            self.connectControl()
            self.testResponseMessage()
        }
    }
}

struct ConnectionTransferView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Text("Developing features...")
                        .font(.custom("SamsungOneKorean-400", size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .navigationTitle("Data Transfer")
        .refreshable {
        }
    }
}

struct ConnectionCalculateView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Text("Developing features...")
                        .font(.custom("SamsungOneKorean-400", size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .navigationTitle("Position Calculate")
        .refreshable {
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
