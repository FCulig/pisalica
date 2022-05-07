//
//  DecodableShopItem.swift
//  edu-app
//
//  Created by Filip Culig on 30.04.2022..
//

import Foundation

// MARK: - DecodableShopItem -

struct DecodableShopItem: Decodable {
    let name: String
    let type: String
    let unboughtImage: String
    let boughtImage: String
    let selectedImage: String
    let hexColor: String

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case unboughtImage
        case boughtImage
        case selectedImage
        case hexColor
    }
}
