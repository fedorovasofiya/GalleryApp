//
//  GalleryViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine

final class GalleryViewModel: GalleryViewOutput {
    
    // MARK: - Public Properties
    
    var dataLoadResultPublisher: PassthroughSubject<Result<Void, Error>, Never>? = PassthroughSubject()
    
    // MARK: - Private Properties
    
    private var data: [ImageModel] = []
    private let authService: AuthService
    private let imageFetchService: ImageFetchService
    private weak var coordinator: GalleryCoordinator?
    
    init(authService: AuthService, imageFetchService: ImageFetchService, coordinator: GalleryCoordinator?) {
        self.authService = authService
        self.imageFetchService = imageFetchService
        self.coordinator = coordinator
    }
    
    func getCount() -> Int {
        return data.count
    }
    
    func getImageData(index: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard !data.isEmpty, data.indices.contains(index) else {
            completion(.failure(NetworkError.noData))
            return
        }
        imageFetchService.loadImageData(from: data[index].url, completion: completion)
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func didSelectItem(at index: Int) {
        guard data.indices.contains(index) else { return }
        coordinator?.openDetailsScreen(for: index, data: data)
    }
    
    func didTapExit() {
        authService.logOut()
        coordinator?.openGalleryScreen()
    }
    
    private func loadData() {
        imageFetchService.fetchImages { completion in
             switch completion {
             case .failure(let error):
                 self.dataLoadResultPublisher?.send(.failure(error))
             case .success(let data):
                 self.data = data
                 self.dataLoadResultPublisher?.send(.success(()))
             }
         }
     }
    
}
