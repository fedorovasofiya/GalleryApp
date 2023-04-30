//
//  AuthService.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol AuthService: VkAPIService {
    func getAuthDialogURLRequest() -> URLRequest?
    func saveAccount(from url: URL?, completion: (Result<Void, Error>) -> Void)
    func cleanCache()
}
