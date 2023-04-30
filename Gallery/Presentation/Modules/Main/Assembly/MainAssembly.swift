//
//  MainAssembly.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

protocol MainAssembly {
    func makeMainModule(coordinator: MainCoordinator) -> UIViewController
}
