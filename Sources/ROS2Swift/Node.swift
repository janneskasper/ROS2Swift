//
//  File.swift
//  
//
//  Created by Jannes Kasper on 07.07.23.
//

import Foundation
import FastRTPSBridge

public class Publisher<T: DDSType>{
    private let topic: any DDSWriterTopic
    private let type: T.Type
    private let context: FastRTPSBridge
    
    init(topic: any DDSWriterTopic, context: FastRTPSBridge, type: T.Type) {
        self.topic = topic
        self.context = context
        self.type = type
    }
    
    deinit {
        do{
            try context.removeWriter(topic: self.topic)
        }catch{
            print(self.topic.rawValue, ": Error when removing publisher: ", error)
        }
    }
    
    public func publish<T: DDSType>(msg: T){
        do{
            try self.context.send(topic: self.topic, ddsData: msg)
        }catch{
            print(self.topic.rawValue, ": Failed to send data: ", error)
        }
    }
}


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
        print(self.name, ": Spinning ...")
        while self.running{
            Thread.sleep(forTimeInterval: TimeInterval(sleepInterval))
        }
    }
    
    public func spinOnce(timeoutSec: Float, sleepInterval: Float = 0.1){
        let start_t = TimeInterval()
        spinOnceFlag = false
        
        print(self.name, ": Spinning once ...")
        while TimeInterval() - start_t < Double(timeoutSec) && !self.spinOnceFlag && self.running{
            Thread.sleep(forTimeInterval: TimeInterval(sleepInterval))
        }
    }
    
    public func runReader(time: Int) throws {
        let t = BaseTopic(name: "test", reliable: false, transientLocal: false)

        try context.registerReader(topic: t) { (val: StringMsg) in
            print("Value:", val)
        }
        for i in 1...time{
            print("Reader waiting ", i)
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
        
    public func runWriter() throws {
        let t = BaseTopic(name: "test", reliable: false, transientLocal: false)
        try context.registerWriter(topic: t, ddsType: StringMsg.self)
        for i in 1...100{
            let msg = StringMsg(val: String(i), id: "1")
            try context.send(topic: t, ddsData: msg)
            Thread.sleep(forTimeInterval: 2.0)
        }
    }
    
    public func shutdown(){
        self.context.stopAll()
        self.context.removeParticipant()
        self.running = false
    }
    
    public func createPublisher<T: DDSType>(topicName: String, topicType: T.Type, reliable: Bool = false, transientLocal: Bool = false) -> Publisher<T>?{
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        do{
            try self.context.registerWriter(topic: topic, ddsType: T.self)
        }catch{
            print(name, ": Failed to register writer on topic: ", topic.rawValue)
            return nil
        }
        return Publisher<T>(topic: topic, context: self.context, type: topicType.self)
    }

    public func createSubscriber<T: DDSType>(topicName: String, callback: @escaping(T) -> Void, reliable: Bool = false, transientLocal: Bool = false){
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        do{
            try self.context.registerReader(topic: topic, completion: callback, subDelegate: self)
        }catch{
            
        }
    }
    
}
