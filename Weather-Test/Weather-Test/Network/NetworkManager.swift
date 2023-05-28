//
//  WeatherAPI.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/25/23.
//

import Foundation

enum NetworkError: Error {
    case fetchWeatherError(error: Error)
    case fetchIconError(error: Error)
}

public protocol NetworkManagerProtocol {
    func fetchWeatherInfoByName(cityName: String?, country: String? , state: String? ) async throws -> Response?
    func fetchIcon(name: String, completionHandler:@escaping  (Data)->Void) throws
    func fetchWeatherInfoByGeoPosition(lat: Double, lon: Double ) async throws -> Response?
}

class NetworkManager: NetworkManagerProtocol {
    public init() {
        //Initialized with no code just not to duplicate same codes for Unit test cases
        //Code can be reusable
    }
    
    func fetchWeatherInfoByName(cityName: String? = nil, country: String? = nil, state: String? = nil) async throws -> Response? {
        let base = URLs.base.string
        guard let cityName = cityName
        else { return nil }
        let urlString = base + "q="+cityName+"&appid="+weatherApplicationInfo.apiKey
        guard let url = URL(string: urlString)
        else{ let error = NSError(domain: "bad url:\(URLs.base.string)", code: -1)
            throw NetworkError.fetchWeatherError(error: error)
        }
        let (data, _) = try await URLSession.shared.data(from:url)
        return try? JSONDecoder().decode(Response.self, from: data)
    }
    
    func fetchIcon(name: String, completionHandler:@escaping  (Data)->Void) throws {
        guard let url = URL(string: URLs.icon(name: name, size: weatherApplicationInfo.iconSize).string)
        else{ let error = NSError(domain: "bad url:\(URLs.base.string)", code: -1)
            throw NetworkError.fetchIconError(error: error)
        }
        URLSession.shared.dataTask(with: url) { (data, r, error) in
            if let data = data {
                completionHandler(data)
            }
        }.resume()
    }
    
    func fetchWeatherInfoByGeoPosition(lat: Double, lon: Double) async throws -> Response? {
        let base = URLs.base.string
        let urlString = base + "lat=\(lat)&lon=\(lon)" + "&appid="+weatherApplicationInfo.apiKey
        guard let url = URL(string: urlString)
        else{ let error = NSError(domain: "bad url:\(URLs.base.string)", code: -1)
            throw NetworkError.fetchWeatherError(error: error)
        }
        let (data, _) = try await URLSession.shared.data(from:url)
        return try? JSONDecoder().decode(Response.self, from: data)
    }
}
