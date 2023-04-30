//
//  Item.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let date: Date
    let sizes: [Size]
}
