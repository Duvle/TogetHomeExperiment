//
//  MainStationFinder.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/23.
//

import Foundation
import Network

protocol MainStationFinderDelegate {
    func didFindServer(finder: MainStationFinder)
}

class MainStationFinder: NSObject {
    let stationPort: NWEndpoint.Port
    
    var delegate: MainStationFinderDelegate?
    var address: String = "127.0.0.1"
    
    var queueLinstener = DispatchQueue(label: "udp-lis.queue", attributes: [])
    var queueConnection = DispatchQueue(label: "udp-con.queue", attributes: [])
    
    public init(portNumber: String) {
        self.stationPort = NWEndpoint.Port(integerLiteral: UInt16(portNumber) ?? 8711) 
    }
    
    public func findStation() {
        // Create Receiver
        guard let stationSocket = try? NWListener(using: .udp, on: self.stationPort) else {
            NSLog("Failed to create socket for Station Finder.")
            return
        }
        
        // Receiver Handler
        stationSocket.newConnectionHandler = { (connection) in
            // IP Split Part
            let resultString: String = connection.debugDescription
            let seperateString: [String.SubSequence] = resultString.split(separator: " ")
            let senderString: String = String(seperateString[1])
            let seperateSenderString: [String.SubSequence] = senderString.split(separator: ":")
            let senderIP: String = String(seperateSenderString[0])
            
            NSLog("Find!! => \(connection.debugDescription)")
            connection.receiveMessage { (content, context, isComplete, error) in
                if let resultError = error {
                    NSLog("An error occurred while receiving UDP Broadcast. [\(resultError)]")
                } else if let resultContent = content {
                    let message = String(data: resultContent, encoding: .utf8)
                    
                    if message == "Toget_Home_Main_Station_Server_17fd1cefff705e7f803e" {
                        self.address = senderIP
                        self.delegate?.didFindServer(finder: self)
                        NSLog("Data = \(message ?? "[EMPTY]")")
                    }
                    
                    // Receiver Close
                    connection.cancel()
                    stationSocket.cancel()
                }
            }
            connection.start(queue: self.queueConnection)
        }
        // Receiver Start
        stationSocket.start(queue: self.queueLinstener)
    }
}
