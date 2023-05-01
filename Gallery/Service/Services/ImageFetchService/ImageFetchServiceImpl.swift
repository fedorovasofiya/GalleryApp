//
//  ImageFetchServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class ImageFetchServiceImpl: ImageFetchService {
    
    // MARK: - Private Properties
    
    private struct Configuration {
        static let apiHost = "api.vk.com"
        static let albumID = "266310117"
        static let ownerID = "-128666765"
    }
    
    private let networkStack: NetworkStack
    private let storageStack: StorageStack
    
    // MARK: - Init

    init(networkStack: NetworkStack, storageStack: StorageStack) {
        self.networkStack = networkStack
        self.storageStack = storageStack
    }
    
    // MARK: - Public methods
    
    func fetchImages(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        guard let request = createPhotosRequest() else {
            completion(.failure(NetworkError.emptyURLRequest))
            return
        }
        networkStack.sendRequest(request) { (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.response.items
                let result = self.mapData(models: data)
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        networkStack.loadData(from: url, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func mapData(models: [Item]) -> [ImageModel] {
        return models.compactMap { model in
            let date = Date(timeIntervalSince1970: TimeInterval(model.date))
            guard let urlString = model.sizes.first(where: { $0.type == "z" })?.url,
                  let url = URL(string: urlString) else {
                return nil
            }
            return ImageModel(id: model.id, date: date, url: url)
        }
    }
    
    private func createPhotosRequest() -> URLRequest? {
        guard let accessToken = getAccessToken() else {
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Configuration.apiHost
        urlComponents.path = "/method/photos.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "owner_id", value: Configuration.ownerID),
            URLQueryItem(name: "album_id", value: Configuration.albumID),
            URLQueryItem(name: "v", value: "5.131")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func getAccessToken() -> String? {
        storageStack.getKey(keyName: "access_token")
    }

}
