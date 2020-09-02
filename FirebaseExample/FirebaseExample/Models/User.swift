//
//  User.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import RealmSwift

// MARK: - User

class User: Object, Codable {
    
    var id = RealmOptional<Int>()
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var address: Address? = nil
    @objc dynamic var phone: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var company: Company? = nil
    var imageUrl: String {
        "https://picsum.photos/id/\((id.value ?? 0) % 1000)/200/200"
//        "https://picsum.photos/seed/picsum/200/200" // Случайная картинка
    }
    
    @objc dynamic var websiteUrl: URL? { URL(string: website) }
    var companyName: String? {
        return company?.name
    }
    
    override class func ignoredProperties() -> [String] {
        return ["websiteUrl"]
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}
