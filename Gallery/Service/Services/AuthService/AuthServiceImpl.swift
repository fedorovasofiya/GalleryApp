//
//  AuthServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import WebKit

final class AuthServiceImpl: AuthService {
    
    private struct Configuration {
        static let host = "oauth.vk.com"
        static let clientID = "51630245"
    }
    
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
    
    func saveAccessToken(from url: URL?, completion: (Result<Void, Error>) -> Void) {
        guard let url = url,
              url.path == "/blank.html",
              let query = url.fragment
        else {
            completion(.failure(AuthError.incorrectURL))
            return
        }
        
        var components = URLComponents()
        components.query = query
        let queryItems = components.queryItems
        
        guard let accessToken = queryItems?.first(where: { $0.name == "access_token" })?.value else {
            completion(.failure(AuthError.noAccessToken))
            return
        }
        guard let expiresInString = queryItems?.first(where: { $0.name == "expires_in" })?.value,
              let expiresIn = Int(expiresInString) else {
            completion(.failure(AuthError.noExpiresIn))
            return
        }
        
        print(accessToken)
        print(expiresIn)
        
        // Access token save
        completion(.success(()))
    }
    
    func cleanCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let date = Date(timeIntervalSince1970: 0)
        if let data = websiteDataTypes as? Set<String> {
            WKWebsiteDataStore.default().removeData(ofTypes: data, modifiedSince: date, completionHandler: {})
        }
    }
}
    
enum AuthError: Error {
    case incorrectURL
    case noAccessToken
    case noExpiresIn
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Invalid URL"
        case .noAccessToken:
            return "There is no access_token param in query items"
        case .noExpiresIn:
            return "There is no expires_in param in query items"
        }
    }
}
