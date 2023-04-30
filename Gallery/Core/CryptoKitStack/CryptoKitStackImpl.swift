//
//  CryptoKitStackImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import CryptoKit

final class CryptoKitStackImpl: CryptoKitStack {
    
    private lazy var encoder: JSONEncoder = JSONEncoder()
    private lazy var decoder: JSONDecoder = JSONDecoder()
    private let userDefaultsStack: UserDefaultsStack
    
    init(userDefaultsStack: UserDefaultsStack) {
        self.userDefaultsStack = userDefaultsStack
    }
    
    // MARK: - Public Methods
    
    func encryptData<T: Encodable>(_ data: T, keyName: String) throws -> AES.GCM.SealedBox {
        let data = try encoder.encode(data)
        let key = getKey(keyName: keyName)
        let encryptedData = try AES.GCM.seal(data, using: key)
        let sealedBoxRestored = try AES.GCM.SealedBox(nonce: encryptedData.nonce, ciphertext: encryptedData.ciphertext, tag: encryptedData.tag)
        return sealedBoxRestored
    }
    
    func decryptData<T: Decodable>(_ sealedBox: AES.GCM.SealedBox, with keyName: String, dataType: T.Type) throws -> T {
        guard let key = readKey(keyName: keyName) else {
            throw CryptoKitError.invalidKey
        }
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        let data = try decoder.decode(T.self, from: decryptedData)
        return data
    }
    
    // MARK: - Private Methods
    
    private func getKey(keyName: String) -> SymmetricKey {
        if let key = readKey(keyName: keyName) {
            return key
        } else {
            let key = SymmetricKey(size: .bits256)
            saveKey(keyName: keyName, key: key)
            return key
        }
    }
    
    private func readKey(keyName: String) -> SymmetricKey? {
        if let keyData = userDefaultsStack.getKey(keyName: keyName, dataType: Data.self) {
            return SymmetricKey(data: keyData)
        } else {
            return nil
        }
    }
    
    private func saveKey(keyName: String, key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data(Array($0)).base64EncodedString() }
        userDefaultsStack.setKey(value: keyData, keyName: keyName)
    }
    
}
