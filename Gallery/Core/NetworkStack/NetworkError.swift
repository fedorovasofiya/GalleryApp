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
    case emptyURLRequest
    case noInternetConnection
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data".localized()
        case .invalidURL:
            return "Invalid URL".localized()
        case .redirect:
            return "Redirect".localized()
        case .badRequest:
            return "Bad request".localized()
        case .serverError:
            return "Server error".localized()
        case .unexpectedStatus:
            return "Unexpected status".localized()
        case .noInternetConnection:
            return "No internet connection".localized()
        case .emptyURLRequest:
            return "There is no URL request to send".localized()
        }
    }
}
