//
//  Level+CoreDataClass.swift
//  edu-app
//
//  Created by Filip Culig on 11.05.2022..
//
//

import CoreData
import Foundation

@objc(Level)
public class Level: NSManagedObject {
    var isDiacritical: Bool {
        return ["Ć", "Č", "ć", "č", "Ž", "ž", "DŽ", "dž", "Š", "š"].contains(name)
    }
}
