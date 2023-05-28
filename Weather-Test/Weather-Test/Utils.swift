//
//  Utils.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/27/23.
//

import Foundation

func getTimeZoneTime(info: Double?) -> Date {
    let value = Date()
    if let timezone = info {
        return value+timezone
    } else {
        return value
    }
}

func double2string(_ value: Double) -> String {
    return String(Int(value))
}

func kelvin2Fahrenheit(_ value: Double) -> Double {
    return (value - 273.15) * 1.8 + 32
}
