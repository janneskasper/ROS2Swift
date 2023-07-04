import XCTest
@testable import ROS2Swift

final class ROS2SwiftTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(ROS2Swift().text, "Hello,
//        let t_pub = TestPubThread()
//        t_pub.start()
        
//        let t_sub = TestSubThread()
//        t_sub.start()
//        print("Starting publisher test thread ...")
//        do{
//            let r = try ROS2Swift()
//            try r.testRun(reader: false)
//        }catch let error{
//            print("Error ...")
//            print(error.localizedDescription)
//            return
//        }
//        print("Testing done ...")
    }
}

//class TestPubThread: Thread {
//    override func main(){
//        print("Starting publisher test thread ...")
//        do{
//            let r = try ROS2Swift()
//            try r.testRun(reader: false)
//        }catch let error{
//            print("Error ...")
//        }
//    }
//}
//class TestSubThread: Thread {
//    override func main(){
//        print("Starting subscriber test thread ...")
//        do{
//            let r = try ROS2Swift()
//            try r.testRun(reader: true)
//        }catch let error{
//            print("Error ...")
//        }
//    }
//}
