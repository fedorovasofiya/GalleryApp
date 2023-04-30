//
//  UserDefaultsStackImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class UserDefaultsStackImpl: UserDefaultsStack {
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public Methods
    
    func setKey<T>(value: T, keyName: String) {
        userDefaults.set(value, forKey: keyName)
    }
    
    func getKey<T>(keyName: String, dataType: T.Type) -> T? {
        userDefaults.object(forKey: keyName) as? T
    }
    
    func removeKey(keyName: String) {
        userDefaults.removeObject(forKey: keyName)
    }
    
}
