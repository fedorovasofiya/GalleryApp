//
//  DetailsViewOutput.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import Combine
import UIKit

protocol DetailsViewOutput {
    var imagePublisher: PassthroughSubject<DisplayingImage, Never>? { get }
    func getCount() -> Int
    func getImageData(index: Int, completion: @escaping (Result<Data, Error>) -> Void)
    func viewDidLoad()
    func didTapBack()
    func didSelectItem(at index: Int)
}
