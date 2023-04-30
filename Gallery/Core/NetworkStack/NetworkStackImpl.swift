//
//  NetworkStackImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class NetworkStackImpl: NetworkStack {
    
    private let session: URLSession = .shared
    private let imageCache = NSCache<NSString, NSData>()
    
    // MARK: - Public Methods
    
    func sendRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                try self?.handleStatusCode(response: response)
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as Data? {
            completion(.success(imageFromCache))
            return
        }
        session.downloadTask(with: url) { url, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let url,
                  let data = try? Data(contentsOf: url)
            else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    private func handleStatusCode(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        switch httpResponse.statusCode {
        case (100...299):
            return
        case (300...399):
            throw NetworkError.redirect
        case (400...499):
            throw NetworkError.badRequest
        case (500...599):
            throw NetworkError.serverError
        default:
            throw NetworkError.unexpectedStatus
        }
    }
    
}
