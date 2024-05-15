//
//  hw4App.swift
//  hw4
//
//  Created by Sana Manesh on 4/8/24.
//

import SwiftUI

@main
struct hw4App: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(weatherViewModel)
        }
    }
}
