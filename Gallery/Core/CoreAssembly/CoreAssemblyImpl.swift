//
//  CoreAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class CoreAssemblyImpl: CoreAssembly {
    
    func makeUserDefaultsStack() -> UserDefaultsStack {
        return UserDefaultsStackImpl()
    }
    
    func makeNetworkStack() -> NetworkStack {
        return NetworkStackImpl()
    }
    
}
