//
//  Photo.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation

struct Photo: Codable {
    let albumId, id: Int
    let title: String
    let url, thumbnailUrl: String
}
