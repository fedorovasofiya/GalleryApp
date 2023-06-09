//
//  ServiceAssembly.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol ServiceAssembly {
    func makeAuthService() -> AuthService
    func makeImageFetchService() -> ImageFetchService
}
