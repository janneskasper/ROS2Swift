import FastRTPSBridge
import Foundation

public struct MsgTypeDescription: Codable, Equatable, Hashable{
    var baseType: String
    var type: String
    
    init(baseType: String, type: String) {
        self.baseType = baseType
        self.type = type
    }
}

public enum MsgBaseTypes: String, CaseIterable, Codable{
    case StdMsgs = "StdMsgs"
    case SensorMsgs = "SensorMsgs"
}

public class MsgTemplate<T: Codable>: DDSKeyed{
    
    public let key: Data
    public var val: T
    public class var ddsTypeName: String { "BaseMsg" }
    
    public init(id: String, val: T) {
        self.key = id.data(using: .utf8)!
        self.val = val
    }
    
    public func getKey() -> String{
        return String(decoding: self.key, as: UTF8.self)

    }
}

class BaseTopic: DDSReaderTopic, DDSWriterTopic{
    var rawValue: String
    var transientLocal: Bool
    var reliable: Bool
    
    required init?(rawValue: String) {
        self.rawValue = rawValue
        self.reliable = false
        self.transientLocal = false
    }
    
    required init(name: String, reliable: Bool = false, transientLocal: Bool = false) {
        self.rawValue = name
        self.transientLocal = transientLocal
        self.reliable = reliable
    }
}

public class ROS2SwiftLogger: RTPSParticipantListenerDelegate{
    public func participantNotification(reason: RTPSParticipantNotification, participant: String, unicastLocators: String, properties: [String : String]) {
        print("Participant (", participant,  ") Notification:", reason.description)
    }
    
    public func readerWriterNotificaton(reason: RTPSReaderWriterNotification, topic: String, type: String, remoteLocators: String) {
        print("ReaderWriter Notification:", reason.description, topic, type)
    }
}
