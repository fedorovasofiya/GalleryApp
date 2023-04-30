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
    
    init(mainAssembly: MainAssembly, authAssembly: AuthAssembly) {
        self.mainAssembly = mainAssembly
        self.authAssembly = authAssembly
    }
    
    func start(in window: UIWindow) {
        let vc = mainAssembly.makeMainModule(coordinator: self)
        window.rootViewController = vc
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
    
}
