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
    private let detailsAssembly: DetailsAssembly
    
    init(authAssembly: AuthAssembly, galleryAssembly: GalleryAssembly, detailsAssembly: DetailsAssembly) {
        self.authAssembly = authAssembly
        self.galleryAssembly = galleryAssembly
        self.detailsAssembly = detailsAssembly
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
    
    func openDetails(for indexPhoto: Int, data: [ImageModel]) {
        let detailsViewController = detailsAssembly.makeDetailsModule(data: data, currentIndex: indexPhoto, coordinator: self)
        (window?.rootViewController as? UINavigationController)?.pushViewController(detailsViewController, animated: true)
    }

}

extension RootCoordinatorImpl: GalleryCoordinator {
    func openAuthScreen() {
        openAuth()
    }
    
    func openGalleryScreen() {
        openGallery()
    }
    
    func openDetailsScreen(for indexPhoto: Int, data: [ImageModel]) {
        openDetails(for: indexPhoto, data: data)
    }
}

extension RootCoordinatorImpl: AuthCoordinator {
    func successfullyAuthorized() {
        openGallery()
    }
    
    func closeAuth() {
        window?.rootViewController?.dismiss(animated: true)
    }
}

extension RootCoordinatorImpl: DetailsCoordinator {
    func closeDetails() {
        (window?.rootViewController as? UINavigationController)?.popViewController(animated: true)
    }
}
