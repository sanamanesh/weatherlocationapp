//
//  HomeView.swift
//  hw4
//
//  Created by Sana Manesh on 4/9/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var locationInput: String = ""
    @State private var isWeatherViewPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter city", text: $locationInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    Task {
                        // Call your asynchronous function here
                        await weatherViewModel.updateCurrLoc(currLocString: locationInput)
                        
                        // After the asynchronous operation is completed, navigate to WeatherView
                        isWeatherViewPresented = true
                    }
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                .disabled(locationInput.isEmpty)
                .sheet(isPresented: $isWeatherViewPresented, content: {
                    // Present WeatherView
                    WeatherView(location: weatherViewModel.currLoc!, index: weatherViewModel.index, weatherViewModel: _weatherViewModel)
                })
                
                Text("Favorites:")
                    .bold()
                    .frame(alignment: .leading)
                List(Array(weatherViewModel.locations.enumerated()), id: \.element.id) { index, loc in
                    if weatherViewModel.isFavorited(loc: loc) {
                        NavigationLink(destination: WeatherView(location: loc, index: index, weatherViewModel: _weatherViewModel)) {
                            Text("\(loc.name)")
                        }
                    }
                }
                
                Text("Others:")
                    .bold()
                    .frame(alignment: .leading)
                List(Array(weatherViewModel.locations.enumerated()), id: \.element.id) { index, loc in
                    if !weatherViewModel.isFavorited(loc: loc) {
                        NavigationLink(destination: WeatherView(location: loc, index: index, weatherViewModel: _weatherViewModel)) {
                            Text("\(loc.name)")
                        }
                    }
                }
                
            }
            .padding()
        }
        
    }
}
