//
//  Album.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation

struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
