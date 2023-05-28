//
//  WeatherReportViewModel.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/27/23.
//

import Foundation
import SwiftUI

class WeatherReportViewModel: ObservableObject {
    static let userDefaultKey = "weather_city"
    @MainActor @Published var weatherInfo = WeatherInfomation() //Until we keep @MainActor @Published, there is no update on view's body to show UI once after API data is received
    
    private let networkManager: NetworkManagerProtocol
    private let locationManager: LocationManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, locationManager: LocationManagerProtocol) {
        self.networkManager = networkManager
        self.locationManager = locationManager
    }
    
    func loadData() async {
        var response: Response?
        do {
            if let cityName = await weatherInfo.cityName {
                //Entered city name in search bar
                response = try? await networkManager.fetchWeatherInfoByName(cityName: cityName,
                                                                            country: nil, state: nil)
            } else if let cityName = UserDefaults.standard.object(forKey: Self.userDefaultKey) as? String {
                //last stored city
                response = try? await networkManager.fetchWeatherInfoByName(cityName: cityName ,
                                                                            country: nil, state: nil)
            }
            else if let position = locationManager.getLocationPosition() {
                // user's location city
                response = try await networkManager.fetchWeatherInfoByGeoPosition(lat: position.lat, lon: position.lon)
            }
            else {
                // default city
                await MainActor.run {
                    weatherInfo.cityName = weatherApplicationInfo.defaultCity
                }
                response = try? await networkManager.fetchWeatherInfoByName(cityName: weatherInfo.cityName,
                                                                            country: nil, state: nil)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        if let response = response {
            await saveResponseToinfo(response)
            await saveLastCityName()
            // download icon
            if let iconName = response.weather?.first?.icon {
                try? networkManager.fetchIcon(name: iconName){ data in
                    DispatchQueue.main.async {
                        self.weatherInfo.icon = Image(uiImage: (UIImage(data: data) ?? UIImage(systemName: weatherApplicationInfo.defaultIcon)!))
                    }
                }
            }
        }
    }
    
    @MainActor private func saveLastCityName()  {
        if let cityName = self.weatherInfo.cityName {
            //Save last entered city name in User defaults to show for the next app launch automatically
            UserDefaults.standard.set(cityName, forKey: Self.userDefaultKey)
        }
    }
    
    @MainActor private func saveResponseToinfo(_ response: Response) {
        self.weatherInfo.cityName = response.name
        self.weatherInfo.lat = response.coord?.lat
        self.weatherInfo.lon = response.coord?.lon
        self.weatherInfo.temp = response.main?.temp
        self.weatherInfo.feelsLike = response.main?.feels_like
        self.weatherInfo.main = response.weather?.first?.main
        self.weatherInfo.windSpeed = response.wind?.speed
        self.weatherInfo.windDegree = response.wind?.deg
        self.weatherInfo.pressure = response.main?.pressure
        self.weatherInfo.humidity = response.main?.humidity
        self.weatherInfo.visibility = response.visibility
        self.weatherInfo.timezone = response.timezone
    }
}
