//
//  DetailsViewOutput.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol DetailsViewOutput {
    func getCount() -> Int
    func getImageData(index: Int, completion: @escaping (Result<Data, Error>) -> Void)
    func viewDidLoad()
    func didTapBack()
}
