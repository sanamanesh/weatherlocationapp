//
//  DataModel.swift
//  hw4
//
//  Created by Sana Manesh on 4/9/24.
//

import Foundation


struct Location: Hashable, Identifiable, Codable {
    var id: String { "\(lat),\(lon)" }
    let lat: Double
    let lon: Double
    let name: String
    let display_name: String

    enum CodingKeys: String, CodingKey {
        case lat, lon, name, display_name
    }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let latDouble = try? container.decode(Double.self, forKey: .lat), let lonDouble = try? container.decode(Double.self, forKey: .lon) {
                // If lat and lon are already doubles, use them directly
                self.lat = latDouble
                self.lon = lonDouble
            } else {
                // If lat and lon are strings, attempt to convert them to doubles
                let latString = try container.decode(String.self, forKey: .lat)
                let lonString = try container.decode(String.self, forKey: .lon)
                guard let lat = Double(latString), let lon = Double(lonString) else {
                    throw DecodingError.dataCorruptedError(forKey: .lat, in: container, debugDescription: "Latitude and longitude values are not valid numbers.")
                }
                
                self.lat = lat
                self.lon = lon
            }
            
            self.name = try container.decode(String.self, forKey: .name)
            self.display_name = try container.decode(String.self, forKey: .display_name)
        }
}


struct Address: Codable {
    let city: String?
    let county: String?
    let state: String?
    let country: String?
    let country_code: String?
}

struct WeatherInfo: Codable {
    let timestamp = Date()
    let hourly_units: HourlyUnits
    let data: WeatherData
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hourly_units = try container.decode(HourlyUnits.self, forKey: .hourly_units)
        data = try container.decode(WeatherData.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case hourly_units
        case data = "hourly"
    }
}

struct HourlyUnits: Codable {
    let time: String
    let temperature_2m: String
    let precipitation_probability: String
    let precipitation: String
}

struct WeatherData: Codable {
    let time: [String]
    let temperature: [Double]
    let precipitation_probability: [Int]
    let precipitation: [Double]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode([String].self, forKey: .time)
        temperature = try container.decode([Double].self, forKey: .temperature)
        precipitation_probability = try container.decode([Int].self, forKey: .precipitation_probability)
        precipitation = try container.decode([Double].self, forKey: .precipitation)
    }
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case precipitation_probability
        case precipitation
    }
}


//struct WeatherInfo: Decodable {
//    var timezone: String
//    let timestamp = Date()
//    let hourly_units: HourlyUnits
//    let data: WeatherData
//
//    enum CodingKeys: String, CodingKey {
//        case hourly_units = "hourly_units"
//        case data = "hourly"
//    }
//}
//
//struct WeatherData: Decodable {
//    let time: [String]
//    let temperature: [Double]
//    let precipitation_probability: [Int]
//    let precipitation: [Double]
//
//    enum CodingKeys: String, CodingKey {
//        case time
//        case temperature = "temperature_2m"
//        case precipitation_probability
//        case precipitation
//    }
//}
//
//struct HourlyUnits: Decodable {
//    let time: String
//    let temperature_2m: String
//    let precipitation_probability: String
//    let precipitation: String
//  }
