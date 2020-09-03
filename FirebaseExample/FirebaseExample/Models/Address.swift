//
//  Address.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import RealmSwift

// MARK: - Address

class Address: Object, Codable {
    
    @objc dynamic var street: String = ""
    @objc dynamic var suite: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var zipcode: String = ""
    @objc dynamic var geo: Geo? = nil
}
