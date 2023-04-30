//
//  GalleryCoordinator.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol GalleryCoordinator: RootCoordinator {
    func openAuthScreen()
    func openGalleryScreen()
    func openDetailsScreen(for indexPhoto: Int, data: [ImageModel])
}
