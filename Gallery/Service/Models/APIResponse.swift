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

struct Item: Decodable {
    let id: Int
    let date: Date
    let sizes: [Size]
}

struct Size: Decodable {
    let type: String
    let url: String
}
