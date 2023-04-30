//
//  VkAPIServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

class VkAPIServiceImpl {
    
    // MARK: - Public Properties
    
    var accessToken: String?
    var expirationDate: Date?
    
    struct Configuration {
        static let authHost = "oauth.vk.com"
        static let apiHost = "api.vk.com"
        static let clientID = "51630245"
        static let accessTokenParam = "access_token"
        static let expiresInParam = "expires_in"
        static let albumID = "266310117"
        static let ownerID = "-128666765"
    }
    
    // MARK: - Private Properties
    
    private let userDefaultsStack: UserDefaultsStack
    
    init(userDefaultsStack: UserDefaultsStack) {
        self.userDefaultsStack = userDefaultsStack
        self.accessToken = getAccessToken()
        self.expirationDate = getExpirationDate()
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
    
    private func getAccessToken() -> String? {
        userDefaultsStack.getKey(keyName: Configuration.accessTokenParam, dataType: String.self)
    }
    
    private func getExpirationDate() -> Date? {
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

}
