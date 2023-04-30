//
//  URLRequestFactoryImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class URLRequestFactoryImpl: URLRequestFactory {
    
    private struct Configuration {
        static let baseURL = "https://oauth.vk.com"
        static let clientID = "51630245"
    }
    
    func getAuthRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Configuration.baseURL) else { return nil }
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
    
}

// private extension URLRequestFactory {
//    private func url(with path: String) -> URL? {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = Configuration.host
//
//        guard let url = urlComponents.url else {
//            return nil
//        }
//
//        return url
//    }
// }
