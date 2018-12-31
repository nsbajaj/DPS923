//
//  DataModelClasses.swift
//  Purpose - Classes and structs that describe the shape of entities
//

import Foundation

// MARK: - Constructs for importing data

// Example shape for a "Country" entity
struct Country: Decodable {
    let name: String
    let capital: String
    let region: String
}

// MARK: - Constructs for data within the app

struct ExampleAdd {
    let name: String
    let quantity: Int
}

//for the outer container package
struct NdbSearchPackage: Decodable{
    let list: NdbSearchList
}

//for the “list” value
struct NdbSearchList: Decodable{
    let q: String
    let sr: String
    let ds: String
    let start: Int
    let end: Int
    let total: Int
    let group: String?
    let sort: String
    let item: [NdbSearchListItem]
}

//for an “item” value
struct NdbSearchListItem: Decodable{
    let offset: Int
    let group: String
    let name: String
    let ndbno: String
    let ds: String
    let manu: String
}
