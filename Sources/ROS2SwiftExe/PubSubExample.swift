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
class PubSubExample{
    var node: Node

    static func main(){
        if CommandLine.arguments[1] == "r"{
            let startup = PubSubExample(name: "TestReader")
            startup.reader()
        }else if CommandLine.arguments[1] == "w"{
            let startup = PubSubExample(name: "TestWriter")
            startup.writer()
        }else{
            print("Not valid input")
        }
    }

    init(name: String) {
        node = Node(name: name)
    }

    func writer(){
        let pub = node.createPublisher(topicName: "testFloat", topicType: FloatMsg.self)
        Thread.sleep(forTimeInterval: 0.5)
        for i in 1...3{
            print("Send msg with value: ", i)
            let msg = FloatMsg(id: "1", val: Float(i))
            pub?.publish(msg: msg)
            Thread.sleep(forTimeInterval: 1.0)
        }
        node.shutdown()
    }

    func reader(){
        let callback = {(msg: FloatMsg) -> Void in
            print("Bool Msg callback with key: ", msg.getKey(), ", ", msg.val)
        }

        node.createSubscriber(topicName: "testFloat", callback: callback)
        node.spinOnce(topicName: "testFloat1")
        node.shutdown()
    }
}
