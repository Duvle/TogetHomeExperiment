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
        self.ipAddress = finder.address
        self.manager = SocketManager(socketURL: URL(string: "ws://\(self.ipAddress ?? "127.0.0.1"):\(self.mainPort ?? "8710")")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket
        
        // Event Part
        self.connectionState()
        
        self.delegate?.readyConnector(connector: self)
    }
    
    public init(mainPort: String!, udpPort: String!) {
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
            self.responseArrayData = transferData
            self.isArrayDataResponsed = true
        }
        // Home Setup Response ->  [String : Any]
        self.socket.on("home_setup_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Device Register Response ->  [String : Any]
        self.socket.on("device_register_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Register Response -> [String : Any]
        self.socket.on("data_register_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Update Response -> [String : Any]
        self.socket.on("data_update_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
        // Data Delete Response -> [String : Any]
        self.socket.on("data_delete_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSDictionary
            let transferData = receivedData as! [String : Any]
            self.responseDictionaryData = transferData
            self.isDictionaryDataResponsed = true
        }
    }
    
    private func ipsResponse() {
        // IPS Space Calculate Response -> [[String : Any]...]
        self.socket.on("ips_space_response") {dataArray, socketAck in
            let receivedData = dataArray[0] as! NSArray
            let transferData = receivedData as! [[String : Any]]
            self.responseArrayData = transferData
            self.isArrayDataResponsed = true
        }
    }
    
    private func waitResponseDictionaryData() -> [String : Any] {
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
    
    private func waitResponseArrayData() -> [[String : Any]] {
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
    
    // Home Part
    public func homeCheck() -> [String : Any] {
        var optionData: [String : Any] = ["data_type": "Home"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = waitResponseArrayData()
        
        return receivedData[0]
    }
    
    public func homeRegister(homeName: String) -> [String : Any] {
        var optionData: [String : Any] = ["home_name": homeName]
        var receivedData: [String : Any] = [:]
        
        self.socket.emit("home_setup", optionData)
        receivedData = waitResponseDictionaryData()
        
        return receivedData
    }
    
    public func settingUpdate(homeName: String, intervalTime: Int, expireCount: Int) -> [String : Any] {
        var optionData: [String : Any] = ["data_type": "Home", "home_name": homeName, "interval_time": intervalTime, "expire_count": expireCount]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = waitResponseDictionaryData()
        
        return receivedData
    }
    
    // Space Part
    public func spaceRequest() -> [[String : Any]] {
        var optionData: [String : Any] = ["data_type": "Space"]
        var receivedData: [[String : Any]] = []
        
        self.dataRequest(optionData: optionData)
        receivedData = waitResponseArrayData()
        
        return receivedData
    }
    
    public func spaceRegister(spaceName: String, sizeX: Float, sizeY: Float) -> [String : Any] {
        var optionData: [String : Any] = ["data_type": "Space", "familiar_name": spaceName, "size_x": sizeX, "size_y": sizeY]
        var receivedData: [String : Any] = [:]
        
        self.dataRegister(optionData: optionData)
        receivedData = waitResponseDictionaryData()
        
        return receivedData
    }
    
    public func spaceUpdate(spaceID: String, sizeX: Float, sizeY: Float) -> [String : Any] {
        var optionData: [String : Any] = ["data_type": "Space", "space_id": spaceID, "size_x": sizeX, "size_y": sizeY]
        var receivedData: [String : Any] = [:]
        
        self.dataUpdate(optionData: optionData)
        receivedData = waitResponseDictionaryData()
        
        return receivedData
    }
    
    public func spaceDelete(spaceID: String) -> [String : Any] {
        var optionData: [String : Any] = ["data_type": "Space", "space_id": spaceID]
        var receivedData: [String : Any] = [:]
        
        self.dataDelete(optionData: optionData)
        receivedData = waitResponseDictionaryData()
        
        return receivedData
    }
    
}
