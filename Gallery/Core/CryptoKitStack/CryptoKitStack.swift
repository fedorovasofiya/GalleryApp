//
//  CryptoKitStack.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import CryptoKit

protocol CryptoKitStack {
    func encryptData<T: Encodable>(_ data: T, keyName: String) throws -> AES.GCM.SealedBox
    func decryptData<T: Decodable>(_ sealedBox: AES.GCM.SealedBox, with keyName: String, dataType: T.Type) throws -> T
}
