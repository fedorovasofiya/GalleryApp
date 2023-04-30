//
//  URLRequestFactory.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol URLRequestFactory {
    func getAuthRequest() -> URLRequest?
}
