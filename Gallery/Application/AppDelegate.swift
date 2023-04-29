//
//  AppDelegate.swift
//  Gallery
//
//  Created by Sonya Fedorova on 29.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = MainViewController()
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        return true
    }

}
