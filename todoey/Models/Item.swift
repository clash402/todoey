//
//  Item.swift
//  todoey
//
//  Created by Josh Courtney on 5/8/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var dateCreated: Date?
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
