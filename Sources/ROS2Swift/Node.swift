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
    var spinOnceFlags: [String: Bool]

    var running: Bool
    
    public init(name: String, domainID: Int = 1, ipAddress: String="127.0.0.1", logLevel: FastRTPSLogLevel = .info){
        self.context = FastRTPSBridge()
        self.context.setlogLevel(logLevel)

        self.logger = ROS2SwiftLogger()
        self.context.setRTPSParticipantListener(delegate: logger)
        self.name = name
        self.domainID = UInt32(domainID)
        self.ip = ipAddress
        self.spinOnceFlag = false
        self.spinOnceFlags = [:]
        self.running = true
        
        start()
    }
    
    deinit {
        shutdown()
    }
    
    public func start(){
        do{
            try self.context.createParticipant(name: self.name, domainID: UInt32(self.domainID), localAddress: self.ip)
        }catch FastRTPSBridgeError.RTPSContextInitializationError{
            print(name, ": Failed to initialize ROS context")
        }catch{
            print(name, ": Unexpected error when initializing ROS context")
        }
        self.spinOnceFlag = false
        self.spinOnceFlags = [:]
        self.running = true
    }
    
    public func shutdown(){
        if running{
            self.context.resignAll()
            self.context.removeParticipant()
            self.running = false            
        }
    }
    
    public func notify(topic: String) {
        spinOnceFlag = true
        spinOnceFlags[topic] = true
    }
    
    public func spin(sleepInterval: Float = 0.1){
        print(self.name, ": Spinning ...")
        while self.running{
            Thread.sleep(forTimeInterval: TimeInterval(sleepInterval))
        }
    }
    
    func resetFlags(){
        for key in self.spinOnceFlags.keys{
            self.spinOnceFlags[key] = false
        }
        self.spinOnceFlag = false
    }
    
    public func spinOnce(timeoutSec: Double? = nil, sleepIntervalSec: Float = 0.1, topicName: String? = nil){
        resetFlags()
        let start_t = NSDate().timeIntervalSince1970

        if topicName != nil && self.spinOnceFlags[topicName!] != nil{
            print(self.name, ": Spinning once on topic ", topicName!, " ...")
            while (timeoutSec == nil || NSDate().timeIntervalSince1970 - start_t < timeoutSec!) &&
                    !self.spinOnceFlags[topicName!]! &&
                    self.running{
                Thread.sleep(forTimeInterval: TimeInterval(sleepIntervalSec))
            }
        }else{
            print(self.name, ": Spinning once for all topics ...")
            while (timeoutSec == nil || NSDate().timeIntervalSince1970 - start_t < timeoutSec!) &&
                    !self.spinOnceFlag &&
                    self.running{
                Thread.sleep(forTimeInterval: TimeInterval(sleepIntervalSec))
            }
        }
    }
    
    // MARK: Publisher functionalities
    public func createPublisher<T: DDSType>(topicName: String, topicType: T.Type, reliable: Bool = false, transientLocal: Bool = false) -> Publisher<T>?{
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        return createPublisher(topic: topic, topicType: topicType, reliable: reliable, transientLocal: transientLocal)
    }
    
    public func createPublisher<T: DDSType>(topic: any DDSWriterTopic, topicType: T.Type, reliable: Bool = false, transientLocal: Bool = false) -> Publisher<T>?{
        do{
            try self.context.registerWriter(topic: topic, ddsType: T.self)
        }catch{
            print(name, ": Failed to register writer on topic: ", topic.rawValue)
            return nil
        }
        return Publisher<T>(topic: topic, context: self.context, type: topicType.self)
    }

    public func removePublisher(topicName: String) -> Bool{
        return removePublisher(topic: BaseTopic(name: topicName))
    }
    
    public func removePublisher(topic: any DDSWriterTopic) -> Bool{
        do{
            try self.context.removeWriter(topic: topic)
        }catch{
            print(name, ": Failed to remove writer on topic: ", topic.rawValue)
            return false
        }
        return true
    }

    // MARK: Subscriber functionalities
    public func createSubscriber<T: DDSType>(topicName: String, callback: @escaping(T) -> Void, reliable: Bool = false, transientLocal: Bool = false){
        let topic = BaseTopic(name: topicName, reliable: reliable, transientLocal: transientLocal)
        createSubscriber(topic: topic, callback: callback, reliable: reliable, transientLocal: transientLocal)
    }
    
    public func createSubscriber<T: DDSType>(topic: any DDSReaderTopic, callback: @escaping(T) -> Void, reliable: Bool = false, transientLocal: Bool = false){
        do{
            try self.context.registerReader(topic: topic, completion: callback, subDelegate: self)
        }catch{
            print(name, ": Failed to register reader on topic: ", topic.rawValue)
        }
        self.spinOnceFlags[topic.rawValue] = false
    }
    
    public func removeSubscriber(topicName: String) -> Bool{
        return removeSubscriber(topic: BaseTopic(name: topicName))
    }
    
    public func removeSubscriber(topic: any DDSReaderTopic) -> Bool{
        do{
            try self.context.removeReader(topic: topic)
        }catch{
            print(name, ": Failed to remove reader on topic: ", topic.rawValue)
            return false
        }
        self.spinOnceFlags.removeValue(forKey: topic.rawValue)
        return true
    }
}
