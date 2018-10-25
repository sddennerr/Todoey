//
//  Item.swift
//  Todoey
//
//  Created by dener barbosa on 10/22/18.
//  Copyright © 2018 dener barbosa. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool  = false
    @objc dynamic var dateCreated: Date? 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
