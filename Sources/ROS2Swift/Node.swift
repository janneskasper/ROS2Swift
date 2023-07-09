//
//  File.swift
//  
//
//  Created by Jannes Kasper on 07.07.23.
//

import Foundation
import FastRTPSBridge


public class Node: RTPSSubscriberDelegate{
    var context: FastRTPSBridge
    let logger: ROS2SwiftLogger
    let ip: String
    let domainID: UInt32
    let name: String
    
    var spinOnceFlag: Bool
    var running: Bool
    
    public init(name: String, domainID: Int = 1, ipAddress: String="127.0.0.1", logLevel: FastRTPSLogLevel = .info){
        self.context = FastRTPSBridge()
        self.context.setlogLevel(logLevel)
        do{
            try self.context.createParticipant(name: name, domainID: UInt32(domainID), localAddress: ipAddress)
        }catch FastRTPSBridgeError.RTPSContextInitializationError{
            print(name, ": Failed to initialize ROS context")
        }catch{
            print(name, ": Unexpected error when initializing ROS context")
        }
        self.logger = ROS2SwiftLogger()
        self.context.setRTPSParticipantListener(delegate: logger)
        self.name = name
        self.domainID = UInt32(domainID)
        self.ip = ipAddress
        self.spinOnceFlag = false
        self.running = true
    }
    
    deinit {
        shutdown()
    }
    
    public func notify(topic: String) {
        spinOnceFlag = true
    }
    
    public func spin(sleepInterval: Float = 0.1){
        while self.running{
            Thread.sleep(forTimeInterval: TimeInterval(sleepInterval))
        }
    }
    
    public func spinOnce(timeoutSec: Float, sleepInterval: Float = 0.1){
        let start_t = TimeInterval()
        spinOnceFlag = false
        
        while TimeInterval() - start_t < Double(timeoutSec) && !spinOnceFlag{
            Thread.sleep(forTimeInterval: TimeInterval(sleepInterval))
        }
    }
    
    func shutdown(){
        self.context.stopAll()
        self.context.removeParticipant()
        self.running = false
    }
    
    public func createPublisher<T: DDSType>(topicName: String, topicType: T.Type, reliable: Bool = false, transientLocal: Bool = false){
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        do{
            try self.context.registerWriter(topic: topic, ddsType: T.self)
        }catch{
            print(name, ": Failed to register writer on topic: ", topic.rawValue)
        }
    }

    public func createSubscriber<T: DDSType>(topicName: String, callback: @escaping(T) -> Void, reliable: Bool = false, transientLocal: Bool = false){
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        do{
            try self.context.registerReader(topic: topic, completion: callback, subDelegate: self)
        }catch{
            
        }
    }
    
}
