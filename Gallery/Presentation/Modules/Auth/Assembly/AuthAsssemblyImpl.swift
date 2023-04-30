//
//  AuthAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

final class AuthAssemblyImpl: AuthAssembly {
    
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeAuthModule(coordinator: AuthCoordinator) -> UIViewController {
        let authViewModel = AuthViewModel(urlRequestFactory: serviceAssembly.URLRequestFactoryService(), coordinator: coordinator)
        let authViewController = AuthViewController(viewModel: authViewModel)
        return authViewController
    }
    
}
