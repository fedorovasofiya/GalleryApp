//
//  VkAPIServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

class VkAPIServiceImpl {
    
    // MARK: - Public Properties
    
    struct Configuration {
        static let host = "oauth.vk.com"
        static let clientID = "51630245"
        static let accessTokenParam = "access_token"
        static let expiresInParam = "expires_in"
    }
    
    // MARK: - Private Properties
    
    private var accessToken: String?
    private var expirationDate: Date?
    private let userDefaultsStack: UserDefaultsStack
    
    init(userDefaultsStack: UserDefaultsStack) {
        self.userDefaultsStack = userDefaultsStack
        self.accessToken = readAccessToken()
        self.expirationDate = readExpirationDate()
    }
    
    // MARK: - Public Methods
    
    func setAccessToken(accessToken: String) {
        self.accessToken = accessToken
        userDefaultsStack.setKey(value: accessToken, keyName: Configuration.accessTokenParam)
    }
    
    func setExpirationDate(expirationDate: Date) {
        self.expirationDate = expirationDate
        userDefaultsStack.setKey(value: expirationDate, keyName: Configuration.expiresInParam)
    }
    
    // MARK: - Private Methods
    
    private func readAccessToken() -> String? {
        userDefaultsStack.getKey(keyName: Configuration.accessTokenParam, dataType: String.self)
    }
    
    private func readExpirationDate() -> Date? {
        userDefaultsStack.getKey(keyName: Configuration.expiresInParam, dataType: Date.self)
    }
    
}

// MARK: - VkAPIService

extension VkAPIServiceImpl: VkAPIService {
    
    func isTokenValid() -> Bool {
        guard self.accessToken != nil,
              let expirationDate = self.expirationDate else {
            return false
        }
        let currentDate = Date()
        return currentDate < expirationDate
    }
    
    func getAccessToken() -> String? {
        self.accessToken
    }
    
}
