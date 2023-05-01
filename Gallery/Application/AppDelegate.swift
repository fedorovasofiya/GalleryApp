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
        
        let coreAssembly = CoreAssemblyImpl()
        let serviceAssembly = ServiceAssemblyImpl(coreAssembly: coreAssembly)
        coordinator = RootCoordinatorImpl(
            authAssembly: AuthAssemblyImpl(serviceAssembly: serviceAssembly),
            galleryAssembly: GalleryAssemblyImpl(serviceAssembly: serviceAssembly),
            detailsAssembly: DetailsAssemblyImpl(serviceAssembly: serviceAssembly)
        )
        coordinator?.start(in: window)
        
        return true
    }

}
