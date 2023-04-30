//
//  ImageFetchServiceImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class ImageFetchServiceImpl: VkAPIServiceImpl, ImageFetchService {    
    
    // MARK: - Private properties
    
    private let networkStack: NetworkStack

    init(networkStack: NetworkStack, userDefaultsStack: UserDefaultsStack) {
        self.networkStack = networkStack
        super.init(userDefaultsStack: userDefaultsStack)
    }
    
    // MARK: - Public methods
    
    func fetchImages(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        guard let request = createPhotosRequest() else { return }
        networkStack.sendRequest(request) { (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.response.items
                let result = self.mapData(models: data)
                completion(.success(result))
            case .failure(let error):
                print(error)
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
            let date = model.date
            guard let urlString = model.sizes.first(where: { $0.type == "y" })?.url,
                  let url = URL(string: urlString) else {
                return nil
            }
            return ImageModel(id: model.id, date: date, url: url)
        }
    }
    
    private func createPhotosRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Configuration.apiHost
        urlComponents.path = "/method/photos.get"
        print(accessToken)
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: self.accessToken),
            URLQueryItem(name: "owner_id", value: Configuration.ownerID),
            URLQueryItem(name: "album_id", value: Configuration.albumID),
            URLQueryItem(name: "v", value: "5.131")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        print(url)
        return URLRequest(url: url)
    }

}
