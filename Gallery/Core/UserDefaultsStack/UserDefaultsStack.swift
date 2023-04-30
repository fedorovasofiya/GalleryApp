//
//  UserDefaultsStack.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol UserDefaultsStack {
    func setKey<T>(value: T, keyName: String)
    func getKey<T>(keyName: String, dataType: T.Type) -> T?
    func removeKey(keyName: String)
}
