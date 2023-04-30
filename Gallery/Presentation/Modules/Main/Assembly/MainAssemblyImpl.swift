//
//  MainAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation
import UIKit

final class MainAssemblyImpl: MainAssembly {

    func makeMainModule(coordinator: MainCoordinator) -> UIViewController {
        let mainViewModel = MainViewModel(coordinator: coordinator)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        return mainViewController
    }
    
}
