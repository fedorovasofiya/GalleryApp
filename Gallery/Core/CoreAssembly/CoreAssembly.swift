//
//  CoreAssembly.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol CoreAssembly {
    func makeUserDefaultsStack() -> UserDefaultsStack
    func makeNetworkStack() -> NetworkStack
}
