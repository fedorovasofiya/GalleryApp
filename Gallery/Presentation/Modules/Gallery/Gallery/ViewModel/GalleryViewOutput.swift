//
//  GalleryViewOutput.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine

protocol GalleryViewOutput {
    var dataLoadResultPublisher: PassthroughSubject<Result<Void, Error>, Never>? { get }
    func getCount() -> Int
    func getImageData(index: Int, completion: @escaping (Result<Data, Error>) -> Void)
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func didTapExit()
}
