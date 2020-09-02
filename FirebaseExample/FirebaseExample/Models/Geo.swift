//
//  Geo.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import RealmSwift

// MARK: - Geo

class Geo: Object, Codable {
    
    @objc dynamic var lat: String = ""
    @objc dynamic var lng: String = ""
}
