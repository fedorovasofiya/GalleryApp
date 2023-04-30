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
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Incorrect URL"
        case .accessDenied:
            return "Error: Access denied"
        case .noAccessToken:
            return "There is no access_token param in query items"
        case .noExpiresIn:
            return "There is no expires_in param in query items"
        }
    }
}
