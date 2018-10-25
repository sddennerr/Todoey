//
//  Category.swift
//  Todoey
//
//  Created by dener barbosa on 10/22/18.
//  Copyright © 2018 dener barbosa. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
