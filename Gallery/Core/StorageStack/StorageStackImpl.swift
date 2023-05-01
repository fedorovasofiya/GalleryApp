//
//  StorageStackImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation
import KeychainSwift

final class StorageStackImpl: StorageStack {
    
    private let keychain = KeychainSwift()
    
    // MARK: - Public Methods
    
    func setKey(value: String, keyName: String) {
        keychain.set(value, forKey: keyName)
    }
    
    func getKey(keyName: String) -> String? {
        keychain.get(keyName)
    }
    
    func removeKey(keyName: String) {
        keychain.delete(keyName)
    }
    
}
