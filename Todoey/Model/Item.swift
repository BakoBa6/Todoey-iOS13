//
//  Item.swift
//  Todoey
//
//  Created by bako abdullah on 12/23/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//
//

import Foundation
import RealmSwift
class Item: Object {
  @objc dynamic var title:String = ""
  @objc dynamic var isDone:Bool = false
    @objc dynamic var date:Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

