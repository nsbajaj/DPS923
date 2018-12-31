//  DataModelManager.swift
//  Purpose - Is the data model manager module/controller for the app

import Foundation

class DataModelManager {
    
    // MARK: - Data properties
    
    var province = [Province]()
    
    // MARK: - Initializers
    
    init() {
        
        // Load the saved plist
        loadPlist()
        
        if province.count == 0 {
            
            // Load some starter items
            province.append(Province(name: "Ontario", premier: "Doug Ford", area: 1076395))
            province.append(Province(name: "British Columbia", premier: "John Horgan", area: 944735))
            
            // Set their identifiers
            for i in 0..<province.count {
                province[i].id = i + 1
            }
        }
    }
   
    
    // MARK: - Private methods
    
    private func nextProvinceId() -> Int {
        // Look for the maximum "id" value, and return the next usable value
        return province.reduce(0, { max($0, $1.id) }) + 1
    }
    
    private func provinceIndexById(_ id: Int) -> Int? {
        // Look for the index of the desired item
        return province.index(where: {$0.id == id})
    }
    
    private func appDataFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Optional (for learning, inspection, and troubleshooting)
        //print(paths[0])
        return paths[0].appendingPathComponent("appdata.plist")
    }
    
    //Test
    private func nextCityId(provinceID: Int) -> Int {
        // Look for the maximum "id" value, and return the next usable value
        var value: Int = 0
        if let p = provinceById(provinceID){
            value = p.cities.reduce(0, { max($0, $1.id) }) + 1
        }
        return value
    }
    
    // MARK: - Public methods
    
    func savePlist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(province)
            try data.write(to: appDataFilePath(), options: Data.WritingOptions.atomic)
            print(appDataFilePath())
        } catch {
            print("Error encoding item array")
        }
    }
    
    func loadPlist() {
        if let data = try? Data(contentsOf: appDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                province = try decoder.decode([Province].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
    
    func provinceById(_ id: Int) -> Province? {
        // Search for matching identifier
        return province.first(where: {$0.id == id})
    }
    
    func provinceByName(_ name: String) -> Province? {
        // Clean and prepare the name first
        let cleanName = name.trimmingCharacters(in: .whitespaces).lowercased()
        // Search for matching name
        return province.first(where: {$0.name.lowercased() == cleanName})
    }
    
    func provinceAdd(_ newItem: Province) -> Province? {
        // Attempt to add the new item, by verifying non-null data
        // Data should ALSO be validated in the user interface controller that gets the data from the user
        // Doing it here too is done for code/data safety
        if !newItem.name.isEmpty && !newItem.premier.isEmpty && newItem.area > 0 {
            // Set the value of "id"
            newItem.id = nextProvinceId()
            // Save it to the collection
            province.append(newItem)
            return province.last
        }
        return nil
    }
    
    func provinceEdit(_ editedItem: Province) -> Province? {
        // Attempt to locate the item
        if let index = province.index(where: {$0.id == editedItem.id}) {
            
            // Attempt to update the existing item, by verifying non-null data
            // Data should ALSO be validated in the user interface controller that gets the data from the user
            // Doing it here too is done for code/data safety
            if !editedItem.name.isEmpty && !editedItem.premier.isEmpty && editedItem.area > 0 {
                // Save it to the collection
                province[index] = editedItem
                return province[index]
            }
        }
        return nil
    }
    
    func provinceDelete(_ id: Int) -> Bool {
        // Attempt to locate the item
        if let item = provinceIndexById(id) {
            // Yes, has been located, so remove the item
            province.remove(at: item)
            return true
        }
        return false
    }
    
    func provincesSortedById() -> [Province] {
        // Sort the array; include a comparison function
        let sortedProvinces = province.sorted(by: { (p1: Province, p2: Province) -> Bool in return p1.id < p2.id })
        
        return sortedProvinces
    }
    
    func provincesSortedByName() -> [Province] {
        // Sort the array; include a comparison function
        let sortedProvinces = province.sorted(by: { (p1: Province, p2: Province) -> Bool in return p1.name.lowercased() < p2.name.lowercased() })
        
        return sortedProvinces
    }
    
    //Test
    func cityById(cityID: Int, provinceID: Int) -> City? {
        if let province = provinceById(provinceID) {
            // do stuff, and return the city object
            return province.cities.first(where: {$0.id == cityID})
        }
        // If the above statement fails, we return nil, which is appropriate
        return nil
    }
    
    func cityAdd(_ newItem: City) -> City? {
        // Attempt to add the new item, by verifying non-null data
        // Data should ALSO be validated in the user interface controller that gets the data from the user
        // Doing it here too is done for code/data safety
        if !newItem.name.isEmpty && !newItem.mayor.isEmpty && newItem.population > 0 {
            // Set the value of "id" for that province
            newItem.id = nextCityId(provinceID: newItem.province)
            
            //Get the province
            let province = provinceById(newItem.province)
            
            // Save it to the collection
            province?.cities.append(newItem)
            return province?.cities.last
        }
        return nil
    }
    
    func citiesSortedById(provinceID: Int) -> [City] {
        // Sort the array; include a comparison function
        let province = provinceById(provinceID)
        let cities = province?.cities
        let sortedCities = cities?.sorted(by: { (p1: City, p2: City) -> Bool in return p1.id < p2.id })
        
        return sortedCities!
    }
    
    func citiesSortedByName(provinceID: Int) -> [City] {
        // Sort the array; include a comparison function
        let province = provinceById(provinceID)
        let cities = province?.cities
        let sortedCities = cities?.sorted(by: { (p1: City, p2: City) -> Bool in return p1.name.lowercased() < p2.name.lowercased() })
        
        return sortedCities!
    }
    
}
