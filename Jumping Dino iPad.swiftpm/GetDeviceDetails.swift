//
//  GetDeviceDetails.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 6/3/23.
//

import Foundation

public enum iPadModel {
    case iPadAir, iPad, unknown
}

public class GetDeviceDetails {
    static func getModelIdentifier() -> String {
        var sysInfo = utsname()
        uname(&sysInfo)
        let mirror = Mirror(reflecting: sysInfo)
        let deviceIdentifier = mirror.children.reduce("") { identifier, element in
            guard let val = element.value as? Int8, val != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(val)))
        }
        return deviceIdentifier
    }
    
    static func getIPadModel(deviceIdentifier: String) -> iPadModel {
        switch deviceIdentifier {
        case "iPad11,3", "iPad11,4", "iPad13,1", "iPad13,2", "iPad13,16", "iPad13,17":
            return .iPadAir
        case "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4", "iPad3,5", "iPad3,6", "iPad6,11", "iPad6,12", "iPad7,5", "iPad7,6", "iPad7,11", "iPad7,12", "iPad11,6", "iPad11,7", "iPad12,1", "iPad12,2", "iPad13,18", "iPad13,19":
            return .iPad
        default:
            return .unknown
        }
    }
}
