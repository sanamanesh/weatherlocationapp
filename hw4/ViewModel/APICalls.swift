//
//  APICalls.swift
//  hw4
//
//  Created by Sana Manesh on 4/9/24.
//

import Foundation

enum APIError: String, Error {
    case networkError
    case invalidURL
}

class APICalls {
    static let instance = APICalls()
    
    func getLocation(city: String) async throws -> [Location]  {
        let urlString = "https://nominatim.openstreetmap.org/search?q=\(city)&addressdetails=1&format=json"
        
        print("1")
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        print("2")
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("3")
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("4")

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
            print("4.5")
            throw APIError.networkError
        }
        
        print("5")
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Failed to convert JSON data to string")
        }
                
        return try JSONDecoder().decode([Location].self, from: data)
    }
    

    func getWeather(latitude: Double, longitude: Double) async throws -> WeatherInfo {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,precipitation_probability,precipitation&temperature_unit=fahrenheit&forecast_days=1"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
            
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
            throw APIError.networkError
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Failed to convert JSON data to string")
        }
        
        do {
            return try JSONDecoder().decode(WeatherInfo.self, from: data)
        } catch let error {
            print(error)
            return try JSONDecoder().decode(WeatherInfo.self, from: data) // temp just for testing
        }
    }
}


