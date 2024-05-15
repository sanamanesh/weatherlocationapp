//
//  WeatherView.swift
//  hw4
//
//  Created by Sana Manesh on 4/9/24.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    let location: Location
    let index: Int
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    func fixTime(i: Int) -> String {
        var time: String
        if i == 0 {
            time = "12:00AM"
        } else if i <= 9 {
            time = String(weatherViewModel.weathers[self.index].data.time[i].suffix(4)) + "AM"
        } else if i <= 11 {
            time = String(weatherViewModel.weathers[self.index].data.time[i].suffix(5)) + "AM"
        } else if i == 12 {
            time = "12:00PM"
        } else if i <= 21 {
            time = String(weatherViewModel.weathers[self.index].data.time[i - 2].suffix(4)) + "PM"
        } else {
            time = "1" + String(weatherViewModel.weathers[self.index].data.time[i - 2].suffix(4)) + "PM"
        }
        
        return time
    }
    
    func formattedDate(time: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy, HH:mm"
            return formatter.string(from: time)
        }
    
    var body: some View {
        VStack {
            Text("Weather for \(location.name)!")
                .font(.largeTitle)
                .padding(.top, 20)
            
            var time = formattedDate(time: weatherViewModel.weathers[index].timestamp)
            Text("From: \(time)")
            
            List {
                HStack {
                    Text("Time")
                        .padding(.horizontal)
                    Text("Temp")
                        .padding(.horizontal)
                    Text("PP")
                        .padding(.horizontal)
                    Text("Prec")
                        .padding(.horizontal)
                }
                
                ForEach(0...23, id: \.self) { i in
                    
                    let time = fixTime(i: i)
                    let temp: Int = Int(weatherViewModel.weathers[self.index].data.temperature[i])
                    let prec_prob: Int = Int(weatherViewModel.weathers[self.index].data.precipitation_probability[i])
                    let prec: Int = Int(weatherViewModel.weathers[self.index].data.precipitation[i])
                    
                    HStack {
                        Text(time)
                            .padding(.horizontal)
                        Text("\(temp)°F")
                            .padding(.horizontal)
                        Text("\(prec_prob)%")
                            .padding(.horizontal)
                        Text("\(prec) mm")
                            .padding(.horizontal)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    // Call removeLocation method with the desired index
                    weatherViewModel.removeLocation(index: index)
                }) {
                    Text("Delete")
                }
                .padding()
                
                Spacer()
                
                if weatherViewModel.isFavorited(loc: location) {
                    Button("Favorited", systemImage: "star.fill") {
                        weatherViewModel.unfavorite(loc: location)
                    }
                } else {
                    Button("Add to Favorites", systemImage: "star") {
                        weatherViewModel.favorite(loc: location)
                    }
                }
            }
            .padding(.bottom)
            
//            Button(action: {
//                // Call removeLocation method with the desired index
//                weatherViewModel.removeLocation(index: index)
//            }) {
//                Text("Delete")
//            }
//            .padding()
        }
//        .toolbar {
//            ToolbarItem {
//                if weatherViewModel.isFavorited(loc: location) {
//                    Button("Favorited", systemImage: "star.fill") {
//                        weatherViewModel.unfavorite(loc: location)
//                    }
//                } else {
//                    Button("Add to Favorites", systemImage: "star") {
//                        weatherViewModel.favorite(loc: location)
//                    }
//                }
//            }
//        }
    }
    
}
                
