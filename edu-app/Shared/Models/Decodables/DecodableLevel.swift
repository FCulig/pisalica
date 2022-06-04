//
//  DecodableLevel.swift
//  edu-app
//
//  Created by Filip Culig on 18.04.2022..
//

import Foundation

// MARK: - DecodableLevel -

struct DecodableLevel: Decodable {
    let name: String
    let numberOfLines: Int64
    let unlockedImage: String
    let lockedImage: String
    let guideImage: String
    let outlineImage: String
    let wordImage: String
    let isLocked: Bool
    let isWord: Bool
    let results: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case numberOfLines
        case unlockedImage
        case lockedImage
        case guideImage
        case outlineImage
        case wordImage
        case isLocked
        case isWord
        case results
    }
}
