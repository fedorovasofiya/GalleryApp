//
//  AuthViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine
import WebKit

final class AuthViewModel: AuthViewOutput {
    
    lazy var requestPublisher: PassthroughSubject<Result<URLRequest, Error>, Never>? = PassthroughSubject()
    
    private let authService: AuthService
    private weak var coordinator: AuthCoordinator?
    
    init(authService: AuthService, coordinator: AuthCoordinator?) {
        self.authService = authService
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        authService.cleanCache()
        sendAuthDialogRequest()
    }
    
    func reloadRequest() {
        authService.cleanCache()
        sendAuthDialogRequest()
    }
    
    func decidePolicy(decidePolicyFor navigationResponse: WKNavigationResponse, completion: @escaping (Result<WKNavigationResponsePolicy, Error>) -> Void) {
        authService.saveAccount(from: navigationResponse.response.url) { result in
            switch result {
            case .success:
                completion(.success(.cancel))
                coordinator?.successfullyAuthorized()
            case .failure(let error):
                if let error = error as? AuthError {
                    switch error {
                    case .incorrectURL:
                        completion(.success(.allow))
                    case .accessDenied:
                        completion(.success(.cancel))
                        coordinator?.closeAuth()
                    default:
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func failedWithError(_ error: Error, alertAction: (String, @escaping (UIAlertAction) -> Void) -> Void) {
        if (error as NSError).code == -1009 {
            alertAction(AuthError.noInternetConnection.localizedDescription, { _ in self.coordinator?.closeAuth() })
        } else {
            alertAction(error.localizedDescription, { _ in self.coordinator?.closeAuth() })
        }
    }
    
    // MARK: - Private Methods
    
    private func sendAuthDialogRequest() {
        authService.getAuthDialogURLRequest { result in
            requestPublisher?.send(result)
        }
    }
    
}
