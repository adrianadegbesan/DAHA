//
//  Network.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import Foundation
import Network

class Network: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = false
    
    func checkConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.connected = true
                } else {
                    self?.connected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
