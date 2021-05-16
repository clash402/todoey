//
//  Category.swift
//  todoey
//
//  Created by Josh Courtney on 5/8/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    
    let items = List<Item>()
}
