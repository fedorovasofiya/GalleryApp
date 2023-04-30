//
//  ServiceAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class ServiceAssemblyImpl: ServiceAssembly {
    
    private let coreAssembly: CoreAssembly
    
    private lazy var cryptoKitStack: CryptoKitStack = {
        coreAssembly.makeCryptoKitStack()
    }()
    
    private lazy var userDefaultsStack: UserDefaultsStack = {
        coreAssembly.makeUserDefaultsStack()
    }()
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }

    // MARK: - Public Methods
    
    func makeAuthService() -> AuthService {
        AuthServiceImpl(userDefaultsStack: userDefaultsStack)
    }

}
