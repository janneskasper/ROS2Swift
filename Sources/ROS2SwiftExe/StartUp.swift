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
    var node: Node
    
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
        node = Node(name: name)
    }

    func writer(){
        node.createPublisher(topicName: "testBool", topicType: BoolMsg.self)
    }

    func reader(){
        let callback = {(msg: BoolMsg) -> Void in
            print("Bool Msg callback with key: ", msg.key, ", ", msg.val)
        }
        
        node.createSubscriber(topicName: "testBool", callback: callback)
        
    }
}
