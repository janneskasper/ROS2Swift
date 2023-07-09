//
//  File.swift
//  
//
//  Created by Jannes Kasper on 07.07.23.
//

import Foundation
import FastRTPSBridge

    public struct FloatMsg: DDSKeyed {
        public let id: String      // @key
        public let val: Float    // Unit: meters
        public var key: Data { id.data(using: .utf8)! }
        public static var ddsTypeName: String { "test::msg" }
    }
    
    public struct IntMsg: DDSKeyed {
        public let id: String      // @key
        public let val: Int    // Unit: meters
        public var key: Data { id.data(using: .utf8)! }
        public static var ddsTypeName: String { "test::msg" }
    }
    
    public struct StringMsg: DDSKeyed {
        public let id: String      // @key
        public let val: String    // Unit: meters
        public var key: Data { id.data(using: .utf8)! }
        public static var ddsTypeName: String { "test::msg" }
    }
    
    public struct BoolMsg: DDSKeyed {
        public let id: String      // @key
        public let val: Bool    // Unit: meters
        public var key: Data { id.data(using: .utf8)! }
        public static var ddsTypeName: String { "test::msg" }
    }
    
    public struct DoubleMsg: DDSKeyed {
        public let id: String      // @key
        public let val: Double    // Unit: meters
        public var key: Data { id.data(using: .utf8)! }
        public static var ddsTypeName: String { "test::msg" }
    }


