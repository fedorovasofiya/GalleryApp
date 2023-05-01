//
//  AuthError.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

enum AuthError: Error {
    case incorrectURL
    case noAccessToken
    case noExpiresIn
    case accessDenied
    case noInternetConnection
    case emptyURLRequest
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Incorrect URL".localized()
        case .accessDenied:
            return "Access denied".localized()
        case .noAccessToken:
            return "There is no access_token param in query items".localized()
        case .noExpiresIn:
            return "There is no expires_in param in query items".localized()
        case .noInternetConnection:
            return "No internet connection".localized()
        case .emptyURLRequest:
            return "There is no URL request to send".localized()
        }
    }
}
