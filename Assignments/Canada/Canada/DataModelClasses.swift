//
//  DataModelClasses.swift
//  Purpose - Describes the entity classes used in the app
//

import Foundation

class Province: NSObject, Codable {
    
    // When creating a new item, do NOT provide a value for "id"
    // It will get calculated by the data model manager 
    
    // MARK: - Data properties
    
    var id: Int = 0
    var name: String = ""
    var premier: String = ""
    var area: Int = 0
    var cities: [City] = []
    
    // MARK: - Initializers

    // Default initializer
    init(name: String, premier: String, area: Int) {
        // The id property will be set elsewhere (e.g. in the data model manager)
        self.name = name
        self.premier = premier
        self.area = area
    }
}

class City: NSObject, Codable {
    
    // When creating a new item, do NOT provide a value for "id"
    // It will get calculated by the data model manager
    
    // MARK: - Data properties
    
    var id: Int = 0
    var name: String = ""
    var mayor: String = ""
    var population: Int = 0
    var province: Int = 0
    
    // MARK: - Initializers
    
    // Default initializer
    init(name: String, mayor: String, population: Int, province: Int) {
        // The id property will be set elsewhere (e.g. in the data model manager)
        self.name = name
        self.mayor = mayor
        self.population = population
        self.province = province
    }
}
