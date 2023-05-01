//
//  String+Extensions.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}
