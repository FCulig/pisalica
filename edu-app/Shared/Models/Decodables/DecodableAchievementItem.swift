//
//  DecodableAchievementItem.swift
//  edu-app
//
//  Created by Filip Culig on 10.05.2022..
//

import Foundation

// MARK: - DecodableAchievementItem -

struct DecodableAchievementItem: Decodable {
    let name: String
    let key: String
    let medalImage: String
    let target: Int

    enum CodingKeys: String, CodingKey {
        case name
        case key
        case medalImage
        case target
    }
}
