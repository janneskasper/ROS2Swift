import XCTest
@testable import ROS2Swift

final class ROS2SwiftTests: XCTestCase {
    static var node: Node = Node(name: "testNode")
    static var passed: Bool = false
    static var topicName: String = "testFloat"
    
    func testExample() throws {
        let t_sub = TestSubThread()
        t_sub.start()
        
        Thread.sleep(forTimeInterval: 0.5)
        
        let pub = ROS2SwiftTests.node.createPublisher(topicName: ROS2SwiftTests.topicName, topicType: FloatMsg.self)
        
        Thread.sleep(forTimeInterval: 0.5)
        
        print("Send msg with value: ", 5.5)
        let msg = FloatMsg(id: "1", val: Float(5.5))
        pub?.publish(msg: msg)
        
        Thread.sleep(forTimeInterval: 0.5)
        
        
        ROS2SwiftTests.node.shutdown()
        
        XCTAssertTrue(ROS2SwiftTests.passed)
    }
                       
   class TestPubThread: Thread {
       override func main(){
           let pub = ROS2SwiftTests.node.createPublisher(topicName: ROS2SwiftTests.topicName, topicType: FloatMsg.self)
           Thread.sleep(forTimeInterval: 0.5)
           for i in 1...3{
               print("Send msg with value: ", i)
               let msg = FloatMsg(id: "1", val: Float(i))
               pub?.publish(msg: msg)
               Thread.sleep(forTimeInterval: 1.0)
           }
       }
   }
    
   class TestSubThread: Thread {
       override func main(){
           let callback = {(msg: FloatMsg) -> Void in
               print("Received Float message", msg.getKey(), ", ", msg.val)
               ROS2SwiftTests.passed = true
           }

           ROS2SwiftTests.node.createSubscriber(topicName: ROS2SwiftTests.topicName, callback: callback)
           ROS2SwiftTests.node.spinOnce(topicName: ROS2SwiftTests.topicName)
       }
   }
}


