//
//  Category.swift
//  Todoey
//
//  Created by bako abdullah on 12/23/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
   @objc dynamic var name:String = ""
   @objc dynamic var color:String = ""
    let items = List<Item>()
}
