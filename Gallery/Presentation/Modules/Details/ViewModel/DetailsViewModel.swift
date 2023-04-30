//
//  DetailsViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class DetailsViewModel: DetailsViewOutput {
    
    private var data: [ImageModel]
    private var currentIndex: Int
    private let imageFetchService: ImageFetchService
    private weak var coordinator: DetailsCoordinator?
    
    init(data: [ImageModel], currentIndex: Int, imageFetchService: ImageFetchService, coordinator: DetailsCoordinator?) {
        self.data = data
        self.currentIndex = currentIndex
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
        
    }
    
    func didTapBack() {
        coordinator?.closeDetails()
    }
    
}
