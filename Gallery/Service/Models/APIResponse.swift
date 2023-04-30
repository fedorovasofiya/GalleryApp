//
//  APIResponse.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

struct APIResponse: Decodable {
    let response: Response
}

struct Response: Decodable {
    let count: Int
    let items: [Item]
}
