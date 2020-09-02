//
//  LoginViewController.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 30.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit
import FirebaseAuth

fileprivate let loginSegue = "loginSegue"

class LoginViewController: BaseViewController {
    
    // Some variables
    private var listener: AuthStateDidChangeListenerHandle?
    
    // UI
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard user != nil else { return }
            
            self?.emailTextField.text = ""
            self?.passwordTextField.text = ""
            
            self?.performSegue(withIdentifier: loginSegue, sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let listener = listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonDidTap(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    @IBAction func registrationButtonDidTap(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                Auth.auth().signIn(withEmail: email, password: password)
            }
        }
    }
}
