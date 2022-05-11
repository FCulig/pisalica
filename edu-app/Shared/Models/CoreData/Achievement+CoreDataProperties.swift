//
//  Achievement+CoreDataProperties.swift
//  edu-app
//
//  Created by Filip Culig on 11.05.2022..
//
//

import CoreData
import Foundation

public extension Achievement {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged var id: UUID?
    @NSManaged var key: String?
    @NSManaged var medalImage: String?
    @NSManaged var name: String?
    @NSManaged var target: Int64
    @NSManaged var currentValue: Int64
}

extension Achievement: Identifiable {}
