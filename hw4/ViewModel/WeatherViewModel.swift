//
//  WeatherViewModel.swift
//  hw4
//
//  Created by Sana Manesh on 4/9/24.
//

import Foundation
import CoreData

class WeatherViewModel: ObservableObject {
    @Published var currLocUser : String = ""
    @Published var currLoc : Location?
    @Published var locations: [Location] = []
    @Published var currWeather: WeatherInfo?
    @Published var weathers: [WeatherInfo] = []
    @Published private var favoritedLocations = Set<String>()
    @Published var index: Int = 0
    
    static let shared = WeatherViewModel()
    
    init() {
        loadLocations()
        loadWeathers()
        loadFavorites()
        index = locations.count - 1
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { stores, error in
            if let error {
                fatalError("Oh no! \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Couldn't save: \(error)")
        }
    }
    
    init(favoritedLocations: Set<String> = []) {
        self.favoritedLocations = favoritedLocations
    }
    
    func isFavorited(loc: Location) -> Bool {
        return favoritedLocations.contains(loc.name)
    }
    
    func favorite(loc: Location) {
        favoritedLocations.insert(loc.name)
        saveFavorites()
    }
    
    func unfavorite(loc: Location) {
        favoritedLocations.remove(loc.name)
        saveFavorites()
    }

    
    func updateCurrLoc(currLocString: String) async {
        print("1")
        
        currLocUser = currLocString
        
        print(currLocUser)
        do {
            if let location = try? await APICalls.instance.getLocation(city: currLocString) {
                    self.currLoc = location.first
                    if let loc = self.currLoc {
                        self.locations.append(loc)
                        print("success")
                        print(self.locations.count)
                        for i in 0...(self.locations.count-1) {
                            print("\(i): \(self.locations[i].display_name)")
                        }
                        await getWeather(lat: loc.lat , long: loc.lon)
                        index = locations.count - 1
                        saveLocations()
                    }
            } else {
                // Handle case where API call returns nil (or encounters an error)
                print("LOCATION - Error or nil result from API call")
            }
        }
    }
    
    func getWeather(lat: Double, long:Double) async {
        if let newCurrWeather = try? await APICalls.instance.getWeather(latitude: lat, longitude: long) {
            DispatchQueue.main.async {
                    self.currWeather = newCurrWeather
                    self.weathers.append(newCurrWeather)
                    print("success weather")
                print(self.weathers.count)
                print(newCurrWeather)
                for i in 0...(self.weathers.count-1) {
                    print("\(i):  \(self.weathers[i].data.temperature[0])")
                }
                print("Timestamp: \(newCurrWeather.timestamp)")
                self.saveWeathers()
            }
        } else {
            // Handle case where API call returns nil (or encounters an error)
            print("WEATHER - Error or nil result from API call")
        }
    }
    
    // Function to save locations array to UserDefaults
    private func saveLocations() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(locations)
            UserDefaults.standard.set(data, forKey: "savedLocations")
        } catch {
            print("Error saving locations: \(error.localizedDescription)")
        }
    }
    
    // Function to load locations array from UserDefaults
    private func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: "savedLocations") {
            do {
                let decoder = JSONDecoder()
                let savedLocations = try decoder.decode([Location].self, from: data)
                self.locations = savedLocations
            } catch {
                print("Error loading locations: \(error)")
            }
        }
    }
    
    // Function to save locations array to UserDefaults
    private func saveWeathers() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(weathers)
            UserDefaults.standard.set(data, forKey: "savedWeathers")
        } catch {
            print("Error saving locations: \(error.localizedDescription)")
        }
    }
    
    // Function to load locations array from UserDefaults
    private func loadWeathers() {
        if let data = UserDefaults.standard.data(forKey: "savedWeathers") {
            do {
                let decoder = JSONDecoder()
                let savedWeathers = try decoder.decode([WeatherInfo].self, from: data)
                self.weathers = savedWeathers
            } catch {
                print("Error loading weathers: \(error)")
            }
        }
    }
    
    // Function to save locations array to UserDefaults
    //favoritedLocations = Set<String>()
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(Array(favoritedLocations))
            UserDefaults.standard.set(data, forKey: "savedFavorites")
        } catch {
            print("Error saving favorites: \(error.localizedDescription)")
        }
    }
    
    // Function to load locations array from UserDefaults
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "savedFavorites") {
            do {
                let decoder = JSONDecoder()
                let savedFavorites = try decoder.decode([String].self, from: data)
                self.favoritedLocations = Set(savedFavorites)
            } catch {
                print("Error loading favorites: \(error)")
            }
        }
    }
    
    func removeLocation(index: Int) {
        guard index >= 0 && index < locations.count else {
            return
        }

        locations.remove(at: index)
        weathers.remove(at: index)
        saveLocations()
        
        self.index = locations.count - 1
    }
}


