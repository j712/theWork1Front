//
//  plans.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/15.
//  Copyright © 2018 umeda yodai. All rights reserved.
//
import Foundation
import RealmSwift

class plans: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var plan: String = ""
    @objc dynamic var limit: String = ""
    
    override static func primaryKey() -> String? {
        return "date"
    }
}

