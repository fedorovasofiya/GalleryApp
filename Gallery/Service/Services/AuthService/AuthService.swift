//
//  AuthService.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import Foundation

protocol AuthService {
    var accessToken: String? { get }
    func getAuthDialogURLRequest(completion: (Result<URLRequest, Error>) -> Void)
    func saveAccount(from url: URL?, completion: (Result<Void, Error>) -> Void)
    func cleanCache()
    func isTokenValid() -> Bool
    func logOut()
}
