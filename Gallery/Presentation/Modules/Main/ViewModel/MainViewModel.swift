//
//  MainViewModel.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class MainViewModel: MainViewOutput {
    
    private weak var coordinator: MainCoordinator?
    
    init(coordinator: MainCoordinator?) {
        self.coordinator = coordinator
    }
    
    func didTapEnter() {
        coordinator?.openAuthScreen()
    }
    
}
