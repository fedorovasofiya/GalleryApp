//
//  DetailsViewController.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {
    
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = Constants.lineSpacing
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    private let viewModel: DetailsViewOutput
    private var imageSubscription: Cancellable?
    
    init(viewModel: DetailsViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureButtons()
        setupImageView()
        setupCollectionView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageSubscription?.cancel()
    }
    
    // MARK: - UI Setup
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left",
                           withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up",
                           withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    private func setupImageView() {
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottomInset),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.itemSize),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackButton() {
        viewModel.didTapBack()
    }
    
    @objc private func didTapShare() {

    }
    
    // MARK: - Combine
    
    private func bindViewModel() {
        imageSubscription = viewModel.imagePublisher?
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { model in
                self.navigationItem.title = model.date
                self.imageView.image = model.image
            })
    }

}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath)
                as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        self.viewModel.getImageData(index: indexPath.row) { completion in
            DispatchQueue.main.async {
                switch completion {
                case .failure:
                    break
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    cell.configure(with: image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCount()
    }
}

// MARK: - UICollectionViewDelegate

extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSide = Constants.itemSize
        return CGSize(width: cellSide, height: cellSide)
    }
}

// MARK: - Constants

extension DetailsViewController {
    private struct Constants {
        static let lineSpacing: CGFloat = 2
        static let itemSize: CGFloat = 54
        static let bottomInset: CGFloat = -34
    }
}
