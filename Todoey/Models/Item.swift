//
//  Item.swift
//  Todoey
//
//  Created by Bogdan Orzea on 1/28/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var done: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreatedAt: Date = Date.init(timeIntervalSinceNow: 0)

    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
