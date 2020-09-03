//
//  BaseViewController.swift
//  RealmExample
//
//  Created by Evgenii Semenov on 30.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> ())? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
