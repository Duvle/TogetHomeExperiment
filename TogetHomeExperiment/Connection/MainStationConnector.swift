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
            NSLog("Connected Server")
            self.delegate?.didConnected(connector: self)
        }
        
        // Connection Error
        self.socket.on(clientEvent: .error) {dataArray, socketAck in
            NSLog("Connection Error")
            self.delegate?.didConnectError(connector: self)
        }
        
        // Disconnected Server
        self.socket.on(clientEvent: .disconnect) {dataArray, socketAck in
            NSLog("Disconnected Server")
            self.delegate?.didDisconnected(connector: self)
        }
    }
    
    private func dataRequest(optionData: [String : Any]!) {
        self.socket.emit("data_request", optionData)
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
    }
}
