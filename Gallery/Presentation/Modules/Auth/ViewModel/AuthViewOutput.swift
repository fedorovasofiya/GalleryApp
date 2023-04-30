//
//  AuthViewOutput.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine

protocol AuthViewOutput {
    var requestPublisher: PassthroughSubject<URLRequest, Never>? { get }
    func viewDidLoad()
    func didTapRefresh()
}
