//
//  WeatherManager.swift
//  Wetter
//
//  Created by Jonas Krödel on 14.02.23.
//

import Foundation
import CoreLocation

struct Weather: Codable, Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
}

class WeatherManager: ObservableObject {
    @Published var currentWeather: Weather?
    @Published var hourlyWeather: [Weather]?

    private let locationManager = CLLocationManager()

    init() {
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchWeather(for location: CLLocation) {
        let apiKey = "c32f8f9ff687e79a5d836186243a6962"
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&exclude=minutely,daily,alerts&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.currentWeather = decodedResponse.current
                        self.hourlyWeather = decodedResponse.hourly
                    }
                    return
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }

    func fetchWeatherForCurrentLocation() {
        guard let location = locationManager.location else {
            return
        }
        fetchWeather(for: location)
    }
}

struct WeatherResponse: Codable {
    let current: Weather
    let hourly: [Weather]
}
