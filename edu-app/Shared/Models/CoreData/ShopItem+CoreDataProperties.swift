//
//  ShopItem+CoreDataProperties.swift
//  edu-app
//
//  Created by Filip Culig on 18.05.2022..
//
//

import CoreData
import Foundation

public extension ShopItem {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ShopItem> {
        return NSFetchRequest<ShopItem>(entityName: "ShopItem")
    }

    @NSManaged var boughtImage: String?
    @NSManaged var hexColor: String?
    @NSManaged var id: UUID?
    @NSManaged var isBought: Bool
    @NSManaged var isSelected: Bool
    @NSManaged var name: String?
    @NSManaged var selectedImage: String?
    @NSManaged var type: String?
    @NSManaged var unboughtImage: String?
    @NSManaged var price: Int64
}

extension ShopItem: Identifiable {}
