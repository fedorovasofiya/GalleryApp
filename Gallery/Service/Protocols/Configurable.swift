//
//  Configurable.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

protocol Configurable: AnyObject {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
