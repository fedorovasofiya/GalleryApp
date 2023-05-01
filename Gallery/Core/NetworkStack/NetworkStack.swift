//
//  NetworkStack.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol NetworkStack {
    func sendRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
    func loadData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
