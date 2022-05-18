//
//  CoinsService.swift
//  edu-app
//
//  Created by Filip Culig on 18.05.2022..
//

import CoreData

// MARK: - CoinsService -

class CoinsService {
    private let context: NSManagedObjectContext

    // MARK: - Initializer

    public init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - Public methods -

extension CoinsService {
    var balance: Int {
        return UserDefaults.standard.integer(forKey: "coinsBalance")
    }

    func updateCoins(amountToBeAdded: Int) {
        UserDefaults.standard.set(balance + amountToBeAdded, forKey: "coinsBalance")
    }
}
