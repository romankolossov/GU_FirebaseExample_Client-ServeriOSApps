//
//  AppDelegate.swift
//  FirebaseExample
//
//  Created by Роман Колосов on 01.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
