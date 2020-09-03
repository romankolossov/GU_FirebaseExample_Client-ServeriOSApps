//
//  Config.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 30.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import Foundation

enum DatabaseType {
    
    case database
    case firestore
}

enum Config {
    
    static let databaseType: DatabaseType = .firestore
}
