//
//  UIViewController+Extensions.swift
//  Gallery
//
//  Created by Sonya Fedorova on 01.05.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, okActionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okActionHandler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertWithTryAgain(title: String, message: String, tryAgainActionHandler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try again".localized(), style: .cancel, handler: tryAgainActionHandler))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
}
