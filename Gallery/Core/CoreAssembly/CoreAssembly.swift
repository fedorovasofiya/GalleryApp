//
//  CoreAssembly.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol CoreAssembly {
    func makeCryptoKitStack() -> CryptoKitStack
    func makeUserDefaultsStack() -> UserDefaultsStack
}
