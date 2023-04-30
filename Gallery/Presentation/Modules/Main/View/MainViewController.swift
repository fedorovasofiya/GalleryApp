//
//  MainViewController.swift
//  Gallery
//
//  Created by Sonya Fedorova on 29.04.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var enterButton = UIButton()
    
    private let viewModel: MainViewOutput
    
    // MARK: - Life Cycle
    
    init(viewModel: MainViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleLabel()
        setupEnterButton()
    }
    
    // MARK: - UI Setup
    
    private func setupTitleLabel() {
        titleLabel.text = "Mobile Up\nGallery"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 44, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleOffset),
            titleLabel.widthAnchor.constraint(equalToConstant: Constants.titleWidth),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleTopOffset),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
    }
    
    private func setupEnterButton() {
        enterButton.backgroundColor = .label
        enterButton.layer.cornerRadius = Constants.cornerRadius
        enterButton.setTitleColor(.systemBackground, for: .normal)
        enterButton.setTitle("Вход через VK", for: .normal)
        enterButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        enterButton.addTarget(self, action: #selector(didTapEnter), for: .touchUpInside)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterButton)
        
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.basicOffset),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.basicInset),
            enterButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottomInset)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapEnter() {
        viewModel.didTapEnter()
    }

}

// MARK: - Constants

extension MainViewController {
    private struct Constants {
        static let titleOffset: CGFloat = 24
        static let titleWidth: CGFloat = 227
        static let titleTopOffset: CGFloat = 170
        static let titleHeight: CGFloat = 106
        static let basicOffset: CGFloat = 16
        static let basicInset: CGFloat = -16
        static let bottomInset: CGFloat = -44
        static let buttonHeight: CGFloat = 52
        static let cornerRadius: CGFloat = 12
    }
}
