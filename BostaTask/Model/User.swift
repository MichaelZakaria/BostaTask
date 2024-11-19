//
//  User.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo?
    
    var completeAddress: String {
        return "\(street), \(suite), \(city), \(zipcode)"
    }
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
