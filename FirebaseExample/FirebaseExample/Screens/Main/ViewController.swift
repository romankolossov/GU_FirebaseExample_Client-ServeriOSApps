//
//  ViewController.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class ViewController: BaseViewController {

    // UI
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.refreshControl = refreshControl
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload data...",
                                                     attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    var publicTableView: UITableView {
        tableView
    }
    
    // Some variables
    var users = [FirebaseUser]()
    var usersRef = Database.database().reference(withPath: "users")
    var usersCollection = Firestore.firestore().collection("Users")
    var listener: ListenerRegistration?
    private var searchText: String {
        searchBar.text ?? ""
    }
    private var networkManager = NetworkManager.shared
    
    // MARK: - Lifecucle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch Config.databaseType {
        case .database:
            usersRef.observe(.value) { [weak self] snapshot in
                self?.users.removeAll()
                guard !snapshot.children.allObjects.isEmpty else {
                    self?.loadData()
                    return
                }

                for child in snapshot.children {
                    guard let child = child as? DataSnapshot,
                        let user = FirebaseUser(snapshot: child) else { continue }
                    self?.users.append(user)
                }
                self?.tableView.reloadData()
            }
            
        case .firestore:
            listener = usersCollection.addSnapshotListener { [weak self] snapshot, error in
                self?.users.removeAll()
                guard let snapshot = snapshot else { return }
                
                guard !snapshot.documents.isEmpty else {
                    self?.loadData()
                    return
                }
                
                for document in snapshot.documents {
                    if let user = FirebaseUser(dict: document.data()) {
                        self?.users.append(user)
                    }
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    deinit {
        switch Config.databaseType {
        case .database:
            usersRef.removeAllObservers()
            
        case .firestore:
            listener?.remove()
        }
    }
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadUsers { [weak self] result in
            
            switch result {
            case let .success(users):

                DispatchQueue.main.async {
                    let firebaseUsers = users.map { FirebaseUser(from: $0) }
                    for user in firebaseUsers {
                        
                        switch Config.databaseType {
                        case .database:
                            self?.usersRef.child("\(user.id)").setValue(user.toAnyObject())
                            
                        case .firestore:
                            self?.usersCollection.document("\(user.id)").setData(user.toAnyObject())
                        }
                    }
                    self?.tableView.reloadData()
                    completion?()
                }
                
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func insertRandomUser(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: DetailViewController.storyboardIdentifier, sender: nil)
    }
    
    
    @IBAction func logoutButtonDidTap(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailViewController.storyboardIdentifier {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.user = sender as? FirebaseUser
            }
        }
    }
}
