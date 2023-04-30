//
//  ImageFetchService.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol ImageFetchService {
    func fetchImages(completion: @escaping (Result<[ImageModel], Error>) -> Void)
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
