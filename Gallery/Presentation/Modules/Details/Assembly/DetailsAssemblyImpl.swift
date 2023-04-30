//
//  DetailsAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation
import UIKit

final class DetailsAssemblyImpl: DetailsAssembly {
    
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeDetailsModule(data: [ImageModel], currentIndex: Int, coordinator: DetailsCoordinator) -> UIViewController {
        let detailsViewModel = DetailsViewModel(
            data: data,
            currentIndex: currentIndex,
            imageFetchService: serviceAssembly.makeImageFetchService(),
            coordinator: coordinator
        )
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        return detailsViewController
    }
        
}
