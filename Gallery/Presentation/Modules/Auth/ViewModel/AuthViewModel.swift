//
//  AuthViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine

final class AuthViewModel: AuthViewOutput {
    
    var requestPublisher: PassthroughSubject<URLRequest, Never>? = PassthroughSubject()
    
    private let urlRequestFactory: URLRequestFactory
    private weak var coordinator: AuthCoordinator?
    
    init(urlRequestFactory: URLRequestFactory, coordinator: AuthCoordinator?) {
        self.urlRequestFactory = urlRequestFactory
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        sendAuthDialogRequest()
    }
    
    func didTapRefresh() {
        sendAuthDialogRequest()
    }
    
    private func sendAuthDialogRequest() {
        if let request = urlRequestFactory.getAuthRequest() {
            requestPublisher?.send(request)
        }
    }
    
}
