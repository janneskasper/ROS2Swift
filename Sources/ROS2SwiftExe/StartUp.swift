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
    var ros: ROS2Swift?
    
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
            ros = try ROS2Swift(name: name)
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
