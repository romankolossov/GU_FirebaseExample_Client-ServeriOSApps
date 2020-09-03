//
//  FirebaseUser.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 30.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseUser {
    
    let id: Int
    let name: String
    let address: String
    let contact: String
    let company: String
    let imageUrl: String
    
    let ref: DatabaseReference?
    
    init(id: Int, name: String, address: String, contact: String, company: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.address = address
        self.contact = contact
        self.company = company
        self.imageUrl = imageUrl
        self.ref = nil
    }
    
    convenience init(from userModel: User) {
        let id = userModel.id.value ?? -1
        let name = userModel.name
        let username = userModel.username
        let address = userModel.address
        let addressString = address != nil ? {
            let suite = address!.suite
            let zipcode = address!.zipcode
            let city = address!.city
            let street = address!.street
            let geo = address!.geo
            let geoString = geo != nil ? "(\(geo!.lat), \(geo!.lng))" : ""
            
            return "\(zipcode), \(city),\n\t\(street), \(suite),\n\tgeo: \(geoString)"
        }() : "unknowned"
        
        let phone = userModel.phone
        let email = userModel.email
        let website = userModel.website
        let company = userModel.company
        let companyName = company != nil ? {
            let name = company!.name
            return name
            }() : "unknowned"
        
        let imageUrl = userModel.imageUrl
        
        self.init(id: id,
                  name: "\(name) (\(username))",
                  address: addressString,
                  contact: "📞: \(phone)\n\t📧: \(email)\n\t🖥: http://\(website)",
                  company: companyName, imageUrl: imageUrl)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        guard let id = value["id"] as? Int,
            let name = value["name"] as? String,
            let address = value["address"] as? String,
            let contact = value["contact"] as? String,
            let company = value["company"] as? String,
            let imageUrl = value["imageUrl"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.address = address
        self.contact = contact
        self.company = company
        self.imageUrl = imageUrl
        self.ref = snapshot.ref
    }
    
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let address = dict["address"] as? String,
            let contact = dict["contact"] as? String,
            let company = dict["company"] as? String,
            let imageUrl = dict["imageUrl"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.address = address
        self.contact = contact
        self.company = company
        self.imageUrl = imageUrl
        self.ref = nil
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "address": address,
            "contact": contact,
            "company": company,
            "imageUrl": imageUrl
        ]
    }
}
