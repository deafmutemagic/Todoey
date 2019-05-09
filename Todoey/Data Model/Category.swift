//
//  Category.swift
//  Todoey
//
//  Created by Christopher Murray on 5/6/19.
//  Copyright © 2019 Christopher Murray. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    var items = List<Item>()
}
