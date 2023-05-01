//
//  ServiceAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class ServiceAssemblyImpl: ServiceAssembly {
    
    private let coreAssembly: CoreAssembly
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }

    // MARK: - Public Methods
    
    func makeAuthService() -> AuthService {
        AuthServiceImpl(storageStack: coreAssembly.makeStorageStack())
    }
    
    func makeImageFetchService() -> ImageFetchService {
        ImageFetchServiceImpl(networkStack: coreAssembly.makeNetworkStack(), storageStack: coreAssembly.makeStorageStack())
    }

}
