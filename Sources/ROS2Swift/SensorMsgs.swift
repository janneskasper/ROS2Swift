//
//  File.swift
//  
//
//  Created by Jannes Kasper on 26.07.23.
//

import Foundation


public enum SensorMsgs: String, CaseIterable, Codable{
    case RGBImage = "RGBImage"
    case Image = "Image"
    case PointCloud = "PointCloud"
}
