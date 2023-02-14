//
//  ContentView.swift
//  Wetter
//
//  Created by Jonas Krödel on 14.02.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var weatherManager = WeatherManager()

    var body: some View {
        VStack {
            Text("Current location: \(locationManager.locationString)")
            if let currentWeather = weatherManager.currentWeather {
                Text("Current weather: \(currentWeather.temperature)°C")
            }
            if let hourlyWeather = weatherManager.hourlyWeather {
                ForEach(hourlyWeather) { weather in
                    Text("\(weather.time): \(weather.temperature)°C")
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}
