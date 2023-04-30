//
//  GalleryAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

final class GalleryAssemblyImpl: GalleryAssembly {
    
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeGalleryModule(coordinator: GalleryCoordinator) -> UIViewController {
        let authService = serviceAssembly.makeAuthService()
        if authService.isTokenValid() {
            let galleryViewModel = GalleryViewModel(
                authService: authService,
                imageFetchService: serviceAssembly.makeImageFetchService(),
                coordinator: coordinator
            )
            let galleryViewController = GalleryViewController(viewModel: galleryViewModel)
            return galleryViewController
        }
        let mainViewModel = MainViewModel(coordinator: coordinator)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        return mainViewController
    }
    
}
