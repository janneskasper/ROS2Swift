////
////  File.swift
////
////
////  Created by Jannes Kasper on 04.07.23.
////
//
//import Foundation
//import FastRTPSBridge
//import ROS2Swift
//
//
//
//@main
//class Startup{
//    var node: Node
//
//    static func main(){
//
//        if CommandLine.arguments[1] == "r"{
//            let startup = Startup(name: "TestReader")
//            startup.reader()
//        }else if CommandLine.arguments[1] == "w"{
//            let startup = Startup(name: "TestWriter")
//            startup.writer()
//        }else{
//            print("Not valid input")
//        }
//    }
//
//    init(name: String) {
//        node = Node(name: name)
//    }
//
//    func writer(){
//        let pub = node.createPublisher(topicName: "testString", topicType: StringMsg.self)
//
//        for i in 1...10{
//            let msg = StringMsg(val: "Number " + String(i), id: "1")
//            pub?.publish(msg: msg)
//            Thread.sleep(forTimeInterval: 1.0)
//        }
//    }
//
//    func reader(){
//        let callback = {(msg: StringMsg) -> Void in
//            print("Bool Msg callback with key: ", msg.key, ", ", msg.val)
//        }
//
//        node.createSubscriber(topicName: "testString", callback: callback)
//        node.spin()
//        node.shutdown()
//    }
//}
//
//  File.swift
//
//
//  Created by Jannes Kasper on 04.07.23.
//

import Foundation
import FastRTPSBridge
import ROS2Swift

@main
class Startup{
    var ros: Node?
    
    static func main(){
        
        if CommandLine.arguments[1] == "r"{
            let startup = Startup(name: "TestReader")
            startup.reader()
        }else if CommandLine.arguments[1] == "w"{
            let startup = Startup(name: "TestWriter")
            startup.writer()
        }else{
            print("Not valid input")
        }
    }
    
    init(name: String) {
        do {
            ros = try Node(name: name)
        }catch let error{
            print("Failed to create ROS2Swift: ", error.localizedDescription)
            ros = nil
        }
    }
    
    func writer(){
        do{
            try self.ros?.runWriter()
        }catch let error{
            print("Failed run writer: ", error.localizedDescription)
        }
    }
    
    func reader(){
        let t = (CommandLine.arguments.count > 2) ? Int(CommandLine.arguments[2]) : 1000000

        do{
            try self.ros?.runReader(time: t!)
        }catch let error{
            print("Failed run reader: ", error.localizedDescription)
        }    }
}
