import FastRTPSBridge
import Foundation


struct TestValue: DDSKeyed {
    let id: String      // @key
    let depth: Float    // Unit: meters
    var key: Data { id.data(using: .utf8)! }
    static var ddsTypeName: String { "test::msg" }
}

enum TestReaderTopics: String, DDSReaderTopic, DDSWriterTopic{
    case test1 = "test_1"
    case test2 = "test_2"
    var transientLocal: Bool {false}
    var reliable: Bool {false}
}

public class ROS2Swift: RTPSParticipantListenerDelegate {
    var fastRTPSBridge: FastRTPSBridge?

    public func participantNotification(reason: RTPSParticipantNotification, participant: String, unicastLocators: String, properties: [String : String]) {
        print("participantNotification", participant)
        print("Properties", properties)
    }
    
    public func readerWriterNotificaton(reason: RTPSReaderWriterNotification, topic: String, type: String, remoteLocators: String) {
        print("readerWriterNotification: ", reason.description, topic)
    }
    
    public init(name: String) throws{
        fastRTPSBridge = FastRTPSBridge()
        fastRTPSBridge?.setlogLevel(.info)
//        try fastRTPSBridge?.createParticipant(name: "TestParticipantReader", domainID: 1, localAddress: "127.0.0.1")
        try fastRTPSBridge?.createParticipant(name: name)
        fastRTPSBridge?.setRTPSParticipantListener(delegate: self)
    }
    
    public func runReader(time: Int) throws {
        try fastRTPSBridge?.registerReader(topic: TestReaderTopics.test1) { (val: TestValue) in
            print("Value:", val)
        }
        for var i in 1...time{
            print("Reader waiting ", i)
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    public func runWriter() throws {
        try fastRTPSBridge?.registerWriter(topic: TestReaderTopics.test1, ddsType: TestValue.self)
        for var i in 1...100{
            let msg = TestValue(id: "1",
                                depth: 1.2)
            try fastRTPSBridge?.send(topic: TestReaderTopics.test1, ddsData: msg)
            Thread.sleep(forTimeInterval: 2.0)
        }
    }
    
    public func shutdown(){
        fastRTPSBridge?.resignAll()
        fastRTPSBridge?.stopAll()
        fastRTPSBridge?.removeParticipant()
    }
}
