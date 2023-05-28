//
//  Constants.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/27/23.
//

import Foundation

enum URLs {
    case base
    case icon(name: String, size: Int)
    
    var string: String {
        switch self {
        case .base:
            return "https://api.openweathermap.org/data/2.5/weather?"
        case .icon(let name, let size):
            return "https://openweathermap.org/img/wn/\(name)@\(size)x.png"
        }
    }
}

struct weatherApplicationInfo {
    static let apiKey = "7286f073a1bd5605ee9dec5ca8d5b5b3"
    static let defaultCity = "Atlanta"
    static let defaultIcon = "sun.min"
    static let iconSize = 2
}
