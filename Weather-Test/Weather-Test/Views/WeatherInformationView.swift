//
//  WeatherInformationView.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/27/23.
//

import SwiftUI

struct WeatherInformationView: View {
    @ObservedObject var weatherReportViewModel: WeatherReportViewModel
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter
    }()
    
    @ViewBuilder func timeView() -> some View {
        VStack {
            Text(getTimeZoneTime(info: weatherReportViewModel.weatherInfo.timezone), formatter: dateFormatter)
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
            Text(weatherReportViewModel.weatherInfo.cityName ?? "")
                .font(.largeTitle)
        }
    }
    
    @ViewBuilder func temperatureView() -> some View {
        VStack {
            HStack {
                weatherReportViewModel.weatherInfo.icon ?? Image(systemName: weatherApplicationInfo.defaultIcon)
                if let temp = weatherReportViewModel.weatherInfo.temp {
                    Text(double2string(
                        kelvin2Fahrenheit(temp))
                         + "˚F")
                    .font(.largeTitle)
                }
            }
            HStack {
                if let feelsLike = weatherReportViewModel.weatherInfo.feelsLike,
                   let main = weatherReportViewModel.weatherInfo.main {
                    Text("Feels like " +
                        double2string(
                            kelvin2Fahrenheit(feelsLike)) +
                        "˚F. " +
                        main)
                }
            }
        }
    }
    
      @ViewBuilder func infoView() -> some View {
        HStack {
            Divider().background(.red)
                .frame(maxHeight: 80)
            Spacer().frame(maxWidth: 20)
            VStack(alignment: .leading) {
                // Show wind
                if let speed = weatherReportViewModel.weatherInfo.windSpeed {
                    HStack {
                        Image(systemName: "wind" )
                        Text(double2string(speed)+" m/s   ")
                    }
                }
                // Pressure
                if let pressure = weatherReportViewModel.weatherInfo.pressure {
                    Text("Pressure: " + double2string(pressure)+" hPa")
                }
                // Humidity
                if let humidity = weatherReportViewModel.weatherInfo.humidity {
                    Text("Humidity: " + double2string(humidity)+"%   ")
                }
                // Visibility
                if let visibility = weatherReportViewModel.weatherInfo.visibility {
                    Text("Visibility: " + double2string(visibility/1000)+"km  ")
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if weatherReportViewModel.weatherInfo.cityName == nil &&
                weatherReportViewModel.weatherInfo.temp == nil {
                ProgressView().scaleEffect(2.0, anchor: .center)
            } else {
                VStack {
                    timeView()
                    Spacer().frame(maxHeight: 20)
                    temperatureView()
                    infoView()
                    Spacer()
                }
            }
        }.onAppear {
            Task {@MainActor () -> Void in
                await weatherReportViewModel.loadData()
            }
        }
    }
}
