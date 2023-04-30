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
    
    var requestPublisher: PassthroughSubject<URLRequest, Never>? = PassthroughSubject()
    
    private let authService: AuthService
    private weak var coordinator: AuthCoordinator?
    
    init(authService: AuthService, coordinator: AuthCoordinator?) {
        self.authService = authService
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        authService.cleanCache()
        sendAuthDialogRequest()
    }
    
    func didTapRefresh() {
        authService.cleanCache()
        sendAuthDialogRequest()
    }
    
    func decidePolicy(decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(navigationResponse.response.url)
        authService.saveAccount(from: navigationResponse.response.url) { result in
            switch result {
            case .success:
                decisionHandler(.cancel)
                coordinator?.successfullyAuthorized()
            case .failure(let error):
                if let error = error as? AuthError {
                    switch error {
                    case .accessDenied:
                        decisionHandler(.cancel)
                        coordinator?.close()
                        // FIXME: обработка ошибок
                    default:
                        decisionHandler(.allow)
                    }
                }
            }
        }
    }
    
    private func sendAuthDialogRequest() {
        if let request = authService.getAuthDialogURLRequest() {
            requestPublisher?.send(request)
        }
    }
    
}
