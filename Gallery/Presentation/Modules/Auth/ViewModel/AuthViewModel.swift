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
        sendAuthDialogRequest()
    }
    
    func didTapRefresh() {
        authService.cleanCache()
        sendAuthDialogRequest()
    }
    
    func decidePolicy(decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        authService.saveAccessToken(from: navigationResponse.response.url) { result in
            switch result {
            case .success:
                decisionHandler(.cancel)
            case .failure:
                // FIXME: обработка ошибок
                decisionHandler(.allow)
            }
        }
    }
    
    private func sendAuthDialogRequest() {
        if let request = authService.getAuthDialogURLRequest() {
            requestPublisher?.send(request)
        }
    }
    
}
