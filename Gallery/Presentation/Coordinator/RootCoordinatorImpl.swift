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

    private let authAssembly: AuthAssembly
    private let galleryAssembly: GalleryAssembly
    
    init(authAssembly: AuthAssembly, galleryAssembly: GalleryAssembly) {
        self.authAssembly = authAssembly
        self.galleryAssembly = galleryAssembly
    }
    
    func start(in window: UIWindow) {
        self.window = window
        openGallery()
    }
    
    // MARK: - Navigation
    
    private func openGallery() {
        let galleryViewController = galleryAssembly.makeGalleryModule(coordinator: self)
        let navigationController = UINavigationController(rootViewController: galleryViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func openAuth() {
        let authViewController = authAssembly.makeAuthModule(coordinator: self)
        let navigationController = UINavigationController(rootViewController: authViewController)
        window?.rootViewController?.present(navigationController, animated: true)
    }

}

extension RootCoordinatorImpl: GalleryCoordinator {
    func openAuthScreen() {
        openAuth()
    }
    
    func openGalleryScreen() {
        openGallery()
    }
    
    func openDetails() {
        
    }
}

extension RootCoordinatorImpl: AuthCoordinator {
    func successfullyAuthorized() {
        openGallery()
    }
    
    func close() {
        window?.rootViewController?.dismiss(animated: true)
    }
}
