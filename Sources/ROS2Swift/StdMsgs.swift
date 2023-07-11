//
//  File.swift
//  
//
//  Created by Jannes Kasper on 07.07.23.
//

import Foundation
import FastRTPSBridge

public class StringMsg: Msg<String>{
    public override class var ddsTypeName: String {"StdMsgs::String"}
}
public class FloatMsg: Msg<Float>{
    public override class var ddsTypeName: String {"StdMsgs::Float"}
}
public class IntMsg: Msg<Int>{
    public override class var ddsTypeName: String {"StdMsgs::Int"}
}
public class DoubleMsg: Msg<Double>{
    public override class var ddsTypeName: String {"StdMsgs::Double"}
}
public class BoolMsg: Msg<Bool>{
    public override class var ddsTypeName: String {"StdMsgs::Bool"}
}

public class Msg<T: Decodable & Encodable>: DDSKeyed{
    
    public let key: Data
    public var val: T
    public class var ddsTypeName: String { "BaseMsg" }
    
    public init(id: String, val: T) {
        self.key = id.data(using: .utf8)!
        self.val = val
    }
    
    public func getKey() -> String{
        return key.base64EncodedString()
    }
}
