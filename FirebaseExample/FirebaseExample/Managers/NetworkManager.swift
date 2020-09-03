//
//  NetworkManager.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 24.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case incorrectData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // Some variables
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/users")!
    private var session: URLSession {
        return URLSession.shared
    }
    
    // MARK: - Major methods
    
    func loadUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        session.dataTask(with: baseUrl) { data, response, error in
            guard let data = data, let users = try? JSONDecoder().decode([User].self, from: data) else {
                completion(.failure(.incorrectData))
                return
            }
            
            completion(.success(users))
        }.resume()
    }
}
