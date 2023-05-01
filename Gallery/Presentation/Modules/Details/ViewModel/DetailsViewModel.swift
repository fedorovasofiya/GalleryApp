//
//  DetailsViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine
import UIKit

final class DetailsViewModel: DetailsViewOutput {
    
    lazy var imagePublisher: PassthroughSubject<Result<DisplayingImage, Error>, Never>? = PassthroughSubject()
    
    // MARK: - Private Properties
    
    private var data: [ImageModel]
    private var selectedIndex: Int
    private let imageFetchService: ImageFetchService
    private weak var coordinator: DetailsCoordinator?
    
    init(data: [ImageModel], selectedIndex: Int, imageFetchService: ImageFetchService, coordinator: DetailsCoordinator?) {
        self.data = data
        self.selectedIndex = selectedIndex
        self.imageFetchService = imageFetchService
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
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
        loadImageData(for: selectedIndex)
    }
    
    func didTapBack() {
        coordinator?.closeDetails()
    }
    
    func didSelectItem(at index: Int) {
        self.selectedIndex = index
        loadImageData(for: selectedIndex)
    }
    
    func reload() {
        loadImageData(for: selectedIndex)
    }
    
    // MARK: - Private Methods
    
    private func loadImageData(for index: Int) {
        guard data.indices.contains(index) else { return }
        imageFetchService.loadImageData(from: data[index].url) { result in
            switch result {
            case .success(let imageData):
                let model = self.makeDisplayingImageModel(data: imageData, date: self.data[index].date)
                self.imagePublisher?.send(.success(model))
            case .failure(let error):
                self.imagePublisher?.send(.failure(error))
            }
        }
    }
                                          
    private func makeDisplayingImageModel(data: Data, date: Date) -> DisplayingImage {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        let dateString = formatter.string(from: date)
        return DisplayingImage(date: dateString, image: UIImage(data: data))
    }
}
