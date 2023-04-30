//
//  AuthServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import WebKit
import CryptoKit

final class AuthServiceImpl: AuthService {
    
    var accessToken: String?
    
    // MARK: - Private Properties
    
    private struct Configuration {
        static let authHost = "oauth.vk.com"
        static let clientID = "51630245"
        static let accessTokenParam = "access_token"
        static let expiresInParam = "expires_in"
    }
    
    private var expirationDate: Date?
    private let userDefaultsStack: UserDefaultsStack
    
    // MARK: - Init
    
    init(userDefaultsStack: UserDefaultsStack) {
        self.userDefaultsStack = userDefaultsStack
        self.accessToken = getAccessToken()
        self.expirationDate = getExpirationDate()
    }

    // MARK: - Public Methods
    
    func getAuthDialogURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Configuration.authHost
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Configuration.clientID),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "photos"),
            URLQueryItem(name: "response_type", value: "token")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    func saveAccount(from url: URL?, completion: (Result<Void, Error>) -> Void) {
        do {
            var urlComponents = URLComponents()
            urlComponents.query = try getQuery(url: url)
            try checkPath(in: urlComponents)
            try saveAccessToken(from: urlComponents)
            try saveExpirationDate(from: urlComponents)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func cleanCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let date = Date(timeIntervalSince1970: 0)
        if let data = websiteDataTypes as? Set<String> {
            WKWebsiteDataStore.default().removeData(ofTypes: data, modifiedSince: date, completionHandler: {})
        }
    }

    func isTokenValid() -> Bool {
        guard self.accessToken != nil,
              let expirationDate = self.expirationDate else {
            return false
        }
        let currentDate = Date()
        return currentDate < expirationDate
    }
    
    func logOut() {
        removeAccountData()
    }

    // MARK: - Private Methods
    
    private func getQuery(url: URL?) throws -> String {
        guard let url = url,
              url.path == "/blank.html",
              let query = url.fragment
        else {
            throw AuthError.incorrectURL
        }
        return query
    }
    
    private func checkPath(in components: URLComponents) throws {
        let queryItems = components.queryItems
        if (queryItems?.first(where: { $0.name == "error" })?.value) != nil {
            throw AuthError.accessDenied
        }
    }
    
    private func saveAccessToken(from components: URLComponents) throws {
        let queryItems = components.queryItems
        guard let accessToken = queryItems?.first(where: { $0.name == Configuration.accessTokenParam })?.value else {
            throw AuthError.noAccessToken
        }
        setAccessToken(accessToken: accessToken)
    }
    
    private func saveExpirationDate(from components: URLComponents) throws {
        let queryItems = components.queryItems
        guard let expiresInString = queryItems?.first(where: { $0.name == Configuration.expiresInParam })?.value,
              let expiresIn = Int(expiresInString)
        else {
            throw AuthError.noExpiresIn
        }
        let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        setExpirationDate(expirationDate: expirationDate)
    }
    
    private func setAccessToken(accessToken: String) {
        self.accessToken = accessToken
        userDefaultsStack.setKey(value: accessToken, keyName: Configuration.accessTokenParam)
    }
    
    private func setExpirationDate(expirationDate: Date) {
        self.expirationDate = expirationDate
        userDefaultsStack.setKey(value: expirationDate, keyName: Configuration.expiresInParam)
    }
    
    private func getAccessToken() -> String? {
        userDefaultsStack.getKey(keyName: Configuration.accessTokenParam, dataType: String.self)
    }
    
    private func getExpirationDate() -> Date? {
        userDefaultsStack.getKey(keyName: Configuration.expiresInParam, dataType: Date.self)
    }
    
    private func removeAccountData() {
        userDefaultsStack.removeKey(keyName: Configuration.accessTokenParam)
        userDefaultsStack.removeKey(keyName: Configuration.expiresInParam)
    }
}
