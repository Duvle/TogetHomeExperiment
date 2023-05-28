//
//  MainStationConnector.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/23.
//

import Foundation
import SocketIO

protocol MainStationConnectorDelegate {
    func readyConnector(connector: MainStationConnector)
    func didConnected(connector: MainStationConnector)
    func didConnectError(connector: MainStationConnector)
    func didDisconnected(connector: MainStationConnector)
}

class MainStationConnector: NSObject, MainStationFinderDelegate {
    var delegate: MainStationConnectorDelegate?
    
    private var ipAddress: String! = "127.0.0.1"
    private var mainPort: String!
    private var udpPort: String!
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var finder: MainStationFinder!
    
    private var isDictionaryDataResponsed: Bool = false
    private var isArrayDataResponsed: Bool = false
    private var responseDictionaryData: [String : Any] = [:]
    private var responseArrayData: [[String : Any]] = []
    
    private var emptyDictionaryData: [String : Any] = ["Data": "[Empty]"]
    
    internal func didFindServer(finder: MainStationFinder) {
        NSLog("MainStation Server Find!!")
        self.ipAddress = finder.address
        self.manager = SocketManager(socketURL: URL(string: "ws://\(self.ipAddress ?? "127.0.0.1"):\(self.mainPort ?? "8710")")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket
        
        // Event Part
        self.connectionState()
        self.dataResponse()
        self.ipsResponse()
        
        self.delegate?.readyConnector(connector: self)
    }
    
    public init(mainPort: String!, udpPort: String!) {
        NSLog("MainStation Connector Create!!")
        super.init()
        self.mainPort = mainPort
        self.udpPort = udpPort
        
        // Server Finder Part
        self.finder = MainStationFinder(portNumber: self.udpPort)
        self.finder.delegate = self
        self.finder.findStation()
    }
    
    private func connectionState() {
        // Connected Server
        self.socket.on(clientEvent: .connect) {dataArray, socketAck in
            NSLog("-----------------------------------")
            NSLog("Connected Server")
            NSLog("-----------------------------------")
            self.delegate?.didConnected(connector: self)
        }
        
        // Connection Error
        self.socket.on(clientEvent: .error) {dataArray, socketAck in
            NSLog("-----------------------------------")
            NSLog("Connection Error")
            NSLog("-----------------------------------")
            self.delegate?.didConnectError(connector: self)
        }
        
        // Disconnected Server
        self.socket.on(clientEvent: .disconnect) {dataArray, socketAck in
            NSLog("-----------------------------------")
            NSLog("Disconnected Server")
            NSLog("-----------------------------------")
            self.delegate?.didDisconnected(connector: self)
        }
    }
    
    private func dataRequest(optionData: [String : Any]!) {
        self.socket.emit("data_request", optionData)
        NSLog("-----------------------------------")
        NSLog("DB Data Request")
        NSLog("Option => \(optionData ?? self.emptyDictionaryData)")
        NSLog("-----------------------------------")
    }
    
    private func dataRegister(optionData: [String : Any]!) {
        self.socket.emit("data_register", optionData)
        NSLog("-----------------------------------")
        NSLog("DB Data Register")
        NSLog("Option => \(optionData ?? self.emptyDictionaryData)")
        NSLog("-----------------------------------")
    }
    
    private func dataUpdate(optionData: [String : Any]!) {
        self.socket.emit("data_update", optionData)
        NSLog("-----------------------------------")
        NSLog("DB Data Update")
        NSLog("Option => \(optionData ?? self.emptyDictionaryData)")
        NSLog("-----------------------------------")
    }
    
    private func dataDelete(optionData: [String : Any]!) {
        self.socket.emit("data_delete", optionData)
        NSLog("-----------------------------------")
        NSLog("DB Data Delete")
        NSLog("Option => \(optionData ?? self.emptyDictionaryData)")
        NSLog("-----------------------------------")
    }
    
    private func dataResponse() {
        // Data Request Response -> [[String : Any]...]
        self.socket.on("data_request_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSArray
            let transferData = receivedData as! [[String : Any]]
            
            NSLog("-----------------------------------")
            NSLog("Data Request Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseArrayData = transferData
            self.isArrayDataResponsed = true
        }
        // Home Setup Response ->  [String : Any]
        self.socket.on("home_setup_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Home Setup Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Device Register Response ->  [String : Any]
        self.socket.on("device_register_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Device Register Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Primary Beacon Register Response ->  [String : Any]
        self.socket.on("primary_beacon_register_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Primary Beacon Register Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Register Response -> [String : Any]
        self.socket.on("data_register_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Data Register Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Beacon Power Update Response -> [String : Any]
        self.socket.on("beacon_power_update_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Beacon Power Update Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Update Response -> [String : Any]
        self.socket.on("data_update_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Data Update Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Delete Response -> [String : Any]
        self.socket.on("data_delete_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            
            NSLog("-----------------------------------")
            NSLog("Data Delete Response")
            NSLog("Received Data => \(transferData)")
            NSLog("-----------------------------------")
            
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
    }
    
    private func ipsResponse() {
        // IPS Space Calculate Response -> [String : Any]
        self.socket.on("ips_space_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
    }
    
    private func waitResponseDictionaryData() async throws -> [String : Any] {
        var receivedData: [String: Any] = [:]
        
        while true {
            if self.isDictionaryDataResponsed {
                // Data Responsed
                receivedData = self.responseDictionaryData
                self.responseDictionaryData = [:]
                self.isDictionaryDataResponsed = false
                break
            }
        }
        
        return receivedData
    }
    
    private func waitResponseArrayData() async throws -> [[String : Any]] {
        var receivedData: [[String : Any]] = []
        
        while true {
            if self.isArrayDataResponsed {
                // Data Responsed
                receivedData = self.responseArrayData
                self.responseArrayData = []
                self.isArrayDataResponsed = false
                break
            }
        }
        
        return receivedData
    }
    
    // Connection Part
    public func setConnect() {
        self.socket.connect()
    }
    
    public func setDisconnect() {
        self.socket.disconnect()
    }
    
    // Home Part
    public func homeCheck() async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Home"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData[0]  // valid: Bool, `msg: String, `home_name: String, `interval_time: Int, `expire_count: Int
    }
    
    public func homeRegister(homeName: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["home_name": homeName]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("home_setup", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, `msg: String, `home_name: String, `interval_time: Int, `expire_count: Int
    }
    
    public func settingUpdate(homeName: String, intervalTime: Int, expireCount: Int) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Home", "home_name": homeName, "interval_time": intervalTime, "expire_count": expireCount]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // Space Part
    public func spaceRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Space"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `familiar_name: String, `size_x: Float, `size_y: Float
    }
    
    public func spaceRegister(spaceName: String, sizeX: Float, sizeY: Float) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Space", "familiar_name": spaceName, "size_x": sizeX, "size_y": sizeY]
        var receivedData: [String : Any] = [:]
        
        self.dataRegister(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, `id: String
    }
    
    public func spaceUpdate(spaceID: String, sizeX: Float, sizeY: Float) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Space", "id": spaceID, "size_x": sizeX, "size_y": sizeY]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    public func spaceDelete(spaceID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Space", "id": spaceID]
        var receivedData: [String : Any] = [:]
        
        self.dataDelete(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // User Part
    public func userRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "User"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `user_name: String
    }
    
    public func userRegister(userName: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "User", "user_name": userName]
        var receivedData: [String : Any] = [:]
        
        self.dataRegister(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, `id: String
    }
    
    public func userUpdate(userID: String, userName: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "User", "id": userID, "user_name": userName]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    public func userDelete(userID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "User", "id": userID]
        var receivedData: [String : Any] = [:]
        
        self.dataDelete(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // Device Part
    public func deviceAllRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Device"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `familiar_name: String, `state: String, `user_id: String
    }
    
    public func deviceMyRequest(userID: String) async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Device", "user_id": userID]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `familiar_name: String, `state: String, `user_id: String
    }
    
    public func deviceNewRegister(deviceName: String, userID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["familiar_name": deviceName, "user_id": userID]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("device_register", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, `id: String
    }
    
    public func deviceReRegister(deviceID: String, deviceName: String, userID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["id": deviceID, "familiar_name": deviceName, "user_id": userID]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("device_register", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, `id: String
    }
    
    public func deviceDelete(deviceID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Device", "id": deviceID]
        var receivedData: [String : Any] = [:]
        
        self.dataDelete(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // Beacon Part
    public func beaconAllRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Beacon"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `state: String, `space_id: String, `pos_x: Float, `pos_y: Float, `power: Int, `isPrimary: Bool
    }
    
    public func beaconSpaceRequest(spaceID: String) async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Beacon", "space_id": spaceID]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `state: String, `space_id: String, `pos_x: Float, `pos_y: Float, `power: Int, `isprimary: Bool
    }
    
    public func beaconPriRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Beacon", "isprimary": true]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData  // valid: Bool, `msg: String, `id: String, `state: String, `space_id: String, `pos_x: Float, `pos_y: Float, `power: Int, `isPrimary: Bool
    }
    
    public func beaconRegister(beaconID: String, state: String, spaceID: String, posX: Float, posY: Float, power: Int, isPrimary: Bool) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Beacon", "id": beaconID, "state": state, "space_id": spaceID, "pos_x": posX, "pos_y": posY, "power": power, "isprimary": isPrimary]
        var receivedData: [String : Any] = [:]
        
        self.dataRegister(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, `id: String
    }
    
    public func beaconPowerUpdate(beaconID: String, state: String, rssiData: [Int]) async throws -> [String : Any] {
        let optionData: [String : Any] = ["id" : beaconID, "state": state, "rssi": rssiData]
        var receivedData: [String :Any] = [:]
        
        self.socket.emit("beacon_power_update", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    public func beaconPriUpdate(beaconID: String, isPrimary: Bool) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Beacon", "id": beaconID, "isprimary": isPrimary]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    public func beaconDelete(beaconID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Beacon", "id": beaconID]
        var receivedData: [String : Any] = [:]
        
        self.dataDelete(optionData: optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // Primary Beacon Part
    public func primaryBeaconRegister(spaceID: String, beaconRssiData: [[String : Any]]) async throws -> [String : Any] {
        let optionData: [String : Any] = ["space_id": spaceID, "beacon_rssi_data": beaconRssiData]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("primary_beacon_register", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String
    }
    
    // Position Part
    public func positionDeviceRequest(deviceID: String) async throws -> [String : Any] {
        let optionData: [String : Any] = ["data_type": "Position Data", "device_id": deviceID]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData[0]
    }
    
    public func positionAllRequest() async throws -> [[String : Any]] {
        let optionData: [String : Any] = ["data_type": "Position Data"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = try await waitResponseArrayData()
        
        return receivedData
    }
    
    // IPS Part
    public func ipsSpaceRequest(beaconRssiData: [[String : Any]]) async throws -> [String : Any] {
        let optionData: [String : Any] = ["beacon_rssi_data": beaconRssiData]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("ips_space", optionData)
        receivedData = try await waitResponseDictionaryData()
        
        return receivedData  // valid: Bool, msg: String, space_id: String
    }
    
    public func ipsFinalRequest(spaceID: String, beaconRssiData: [[String : Any]]) {
        let optionData: [String : Any] = ["space_id": spaceID, "beacon_rssi_data": beaconRssiData]
        
        self.socket.emit("ips_final", optionData)
        
        // NO RETURN VALUES
    }
}
