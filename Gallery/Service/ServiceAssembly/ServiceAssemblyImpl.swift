//
//  ServiceAssemblyImpl.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

final class ServiceAssemblyImpl: ServiceAssembly {

    // MARK: - Public Methods
    
    func URLRequestFactoryService() -> URLRequestFactory {
        URLRequestFactoryImpl()
    }

}
