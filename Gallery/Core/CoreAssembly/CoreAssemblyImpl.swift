//
//  CoreAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class CoreAssemblyImpl: CoreAssembly {
    
    func makeCryptoKitStack() -> CryptoKitStack {
        return CryptoKitStackImpl(userDefaultsStack: makeUserDefaultsStack())
    }
    
    func makeUserDefaultsStack() -> UserDefaultsStack {
        return UserDefaultsStackImpl()
    }
}
