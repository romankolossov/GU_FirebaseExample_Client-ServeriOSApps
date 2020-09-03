//
//  ViewController+TableView.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 27.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserInfoTableViewCell.self), for: indexPath) as! UserInfoTableViewCell
        
        let userModel = users[indexPath.item]
        cell.userModel = userModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: DetailViewController.storyboardIdentifier, sender: user)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.item]
            
            switch Config.databaseType {
            case .database:
                user.ref?.removeValue { [weak self] error, _ in
                    if let error = error {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self?.publicTableView.reloadData()
                    }
                }
                
            case .firestore:
                usersCollection.document("\(user.id)").delete { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self?.publicTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        publicTableView.reloadData()
    }
}
