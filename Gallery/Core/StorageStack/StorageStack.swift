//
//  StorageStack.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation

protocol StorageStack {
    func setKey(value: String, keyName: String)
    func getKey(keyName: String) -> String?
    func removeKey(keyName: String)
}
