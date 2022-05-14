//
//  Level+CoreDataProperties.swift
//  edu-app
//
//  Created by Filip Culig on 11.05.2022..
//
//

import CoreData
import Foundation

public extension Level {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Level> {
        return NSFetchRequest<Level>(entityName: "Level")
    }

    @NSManaged var id: UUID?
    @NSManaged var isLocked: Bool
    @NSManaged var lockedImage: String?
    @NSManaged var name: String?
    @NSManaged var numberOfLines: Int64
    @NSManaged var results: [String]?
    @NSManaged var unlockedImage: String?
    @NSManaged var guideImage: String?
    @NSManaged var outlineImage: String?
}

extension Level: Identifiable {}
