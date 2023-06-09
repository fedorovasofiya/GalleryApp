//
//  DetailsAssembly.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation
import UIKit

protocol DetailsAssembly {
    func makeDetailsModule(data: [ImageModel], selectedIndex: Int, coordinator: DetailsCoordinator) -> UIViewController
}
