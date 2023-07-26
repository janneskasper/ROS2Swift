//
//  File.swift
//  
//
//  Created by Jannes Kasper on 07.07.23.
//

import Foundation
import FastRTPSBridge

public enum StdMsgTypes: String, CaseIterable, Codable, Identifiable{
    public var id: Self {self}

    case Int = "Int"
    case Float = "Float"
    case Double = "Double"
    case String = "String"
    case Bool = "Bool"
}

public class StringMsg: MsgTemplate<String>{
    public override class var ddsTypeName: String {"StdMsgs::String"}
}
public class FloatMsg: MsgTemplate<Float>{
    public override class var ddsTypeName: String {"StdMsgs::Float"}
}
public class IntMsg: MsgTemplate<Int>{
    public override class var ddsTypeName: String {"StdMsgs::Int"}
}
public class DoubleMsg: MsgTemplate<Double>{
    public override class var ddsTypeName: String {"StdMsgs::Double"}
}
public class BoolMsg: MsgTemplate<Bool>{
    public override class var ddsTypeName: String {"StdMsgs::Bool"}
}
