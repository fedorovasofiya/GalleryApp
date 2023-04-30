//
//  NetworkError.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidURL
    case redirect
    case badRequest
    case serverError
    case unexpectedStatus
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data"
        case .invalidURL:
            return "Invalid URL"
        case .redirect:
            return "Redirect"
        case .badRequest:
            return "Bad request"
        case .serverError:
            return "Server error"
        case .unexpectedStatus:
            return "Unexpected status"
        }
    }
}
