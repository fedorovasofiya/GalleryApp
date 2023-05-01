//
//  AuthViewOutput.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine
import WebKit

protocol AuthViewOutput {
    var requestPublisher: PassthroughSubject<Result<URLRequest, Error>, Never>? { get }
    func viewDidLoad()
    func reloadRequest()
    func decidePolicy(decidePolicyFor navigationResponse: WKNavigationResponse,
                      completion: @escaping (Result<WKNavigationResponsePolicy, Error>) -> Void)
    func failedWithError(_ error: Error, alertAction: (String, @escaping (UIAlertAction) -> Void) -> Void)
}
