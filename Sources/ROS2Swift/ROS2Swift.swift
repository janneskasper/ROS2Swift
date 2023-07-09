import FastRTPSBridge
import Foundation


class BaseTopic: DDSReaderTopic, DDSWriterTopic{
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
    
    var rawValue: String
    
    var transientLocal: Bool
    var reliable: Bool
}

public class ROS2SwiftLogger: RTPSParticipantListenerDelegate{
    public func participantNotification(reason: RTPSParticipantNotification, participant: String, unicastLocators: String, properties: [String : String]) {
        print("Participant (", participant,  ") Notification: ", reason.description)
    }
    
    public func readerWriterNotificaton(reason: RTPSReaderWriterNotification, topic: String, type: String, remoteLocators: String) {
        print("ReaderWriter Notification: ", reason.description, topic, type)
    }
    
    init() {
        
    }
}
