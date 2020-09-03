//
//  Company.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import RealmSwift

// MARK: - Company

class Company: Object, Codable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var catchPhrase: String = ""
    @objc dynamic var bs: String = ""
}
