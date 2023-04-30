//
//  RootCoordinatorImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

final class RootCoordinatorImpl: RootCoordinator {
    
    private weak var window: UIWindow?

    private let mainAssembly: MainAssembly
    private let authAssembly: AuthAssembly
    private let galleryAssembly: GalleryAssembly
    
    init(mainAssembly: MainAssembly, authAssembly: AuthAssembly, galleryAssembly: GalleryAssembly) {
        self.mainAssembly = mainAssembly
        self.authAssembly = authAssembly
        self.galleryAssembly = galleryAssembly
    }
    
    func start(in window: UIWindow) {
        let mainViewController = mainAssembly.makeMainModule(coordinator: self)
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        self.window = window
    }

}

extension RootCoordinatorImpl: MainCoordinator {
    func openAuthScreen() {
        let authViewController = authAssembly.makeAuthModule(coordinator: self)
        let navigationController = UINavigationController(rootViewController: authViewController)
        window?.rootViewController?.present(navigationController, animated: true)
    }
}

extension RootCoordinatorImpl: AuthCoordinator {
    func successfullyAuthorized() {
        let galleryViewController = galleryAssembly.makeGalleryModule(coordinator: self)
        let navigationController = UINavigationController(rootViewController: galleryViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func close() {
        window?.rootViewController?.dismiss(animated: true)
    }
}

extension RootCoordinatorImpl: GalleryCoordinator {
    func openDetails() {
        
    }
}
