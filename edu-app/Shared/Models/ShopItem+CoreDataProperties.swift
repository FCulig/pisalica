//
//  ShopItem+CoreDataProperties.swift
//
//
//  Created by Filip Culig on 07.05.2022..
//
//

import CoreData
import Foundation

public extension ShopItem {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ShopItem> {
        return NSFetchRequest<ShopItem>(entityName: "ShopItem")
    }

    @NSManaged var boughtImage: String?
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var selectedImage: String?
    @NSManaged var type: String?
    @NSManaged var unboughtImage: String?
    @NSManaged var isSelected: Bool
    @NSManaged var isBought: Bool
    @NSManaged var hexColor: String?
}
