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
    var coordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        
        let serviceAssembly = ServiceAssemblyImpl()
        coordinator = RootCoordinatorImpl(
            mainAssembly: MainAssemblyImpl(),
            authAssembly: AuthAssemblyImpl(serviceAssembly: serviceAssembly)
        )
        
        coordinator?.start(in: window)
        
        return true
    }

}
