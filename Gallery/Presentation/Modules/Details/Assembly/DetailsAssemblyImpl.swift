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
    
    func makeDetailsModule(data: [ImageModel], selectedIndex: Int, coordinator: DetailsCoordinator) -> UIViewController {
        let detailsViewModel = DetailsViewModel(
            data: data,
            selectedIndex: selectedIndex,
            imageFetchService: serviceAssembly.makeImageFetchService(),
            coordinator: coordinator
        )
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        return detailsViewController
    }
        
}
