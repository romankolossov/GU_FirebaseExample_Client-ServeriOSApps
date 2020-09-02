//
//  DetailViewController.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 27.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    static let storyboardIdentifier = "detailScreen"
    
    // UI
    @IBOutlet weak var nameTextField: UITextField!
    
    // Some variables
    var user: FirebaseUser?
    var usersRef = Database.database().reference(withPath: "users")
    var usersCollection = Firestore.firestore().collection("Users")
    
    override func viewDidLoad() {
        
        nameTextField.text = user?.name
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        
        if let user = user {
            editUser(newUser: user)
        } else {
            addUser()
        }
    }
    
    private func editUser(newUser: FirebaseUser) {
        guard let user = user, let name = nameTextField.text else { return }

        let firebaseUser = FirebaseUser(id: user.id,
                                        name: name,
                                        address: user.address,
                                        contact: user.contact,
                                        company: user.company,
                                        imageUrl: user.imageUrl)
        
        switch Config.databaseType {
        case .database:
            saveUserToDatabase(user: firebaseUser)
            
        case .firestore:
            saveUserToFirestore(user: firebaseUser)
        }
    }
    
    private func addUser() {
        guard let name = nameTextField.text else { return }
        
        let user = User()
        user.id.value = Int.random(in: 0...1_000_000)
        user.name = name.isEmpty ? "Some name" : name
        user.username = "Some username"
        user.phone = "+7 999 999 99 99"
        user.email = "email@mail.ru"
        user.website = "https://apple.com"
        
        let firebaseUser = FirebaseUser(from: user)
        
        switch Config.databaseType {
        case .database:
            saveUserToDatabase(user: firebaseUser)
            
        case .firestore:
            saveUserToFirestore(user: firebaseUser)
        }
    }
    
    private func saveUserToDatabase(user: FirebaseUser) {
        usersRef.child("\(user.id)").setValue(user.toAnyObject()) { [weak self] error, _ in
            if let error = error {
                print(error)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func saveUserToFirestore(user: FirebaseUser) {
        usersCollection.document("\(user.id)").setData(user.toAnyObject()) { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
