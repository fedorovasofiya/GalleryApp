//
//  AuthServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import WebKit
import CryptoKit

final class AuthServiceImpl: VkAPIServiceImpl, AuthService {
    
    // MARK: - Public Methods
    
    func getAuthDialogURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Configuration.host
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
    
    // MARK: - Private Methods
    
    private func getQuery(url: URL?) throws -> String {
        guard let url = url,
              let query = url.fragment
        else {
            throw AuthError.incorrectURL
        }
        return query
    }
    
    private func checkPath(in components: URLComponents) throws {
        guard let url = components.url,
              url.path == "/blank.html" else {
            throw AuthError.incorrectURL
        }
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
}
