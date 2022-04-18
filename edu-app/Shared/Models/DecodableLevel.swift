//
//  DecodableLevel.swift
//  edu-app
//
//  Created by Filip Culig on 18.04.2022..
//

import Foundation

struct DecodableLevel: Decodable {
//    let id: UUID
    let name: String
    let numberOfLines: Int64
    let unlockedImage: String
    let lockedImage: String
    let isLocked: Bool
    let results: [String]

    enum CodingKeys: String, CodingKey {
//        case id
        case name
        case numberOfLines
        case unlockedImage
        case lockedImage
        case isLocked
        case results
    }
}
