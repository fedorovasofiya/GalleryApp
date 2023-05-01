//
//  UICollectionViewCell+Extensions.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

extension UICollectionViewCell: Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
