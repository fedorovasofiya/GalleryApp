//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import UIKit
import Combine

final class GalleryViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    private let viewModel: GalleryViewOutput
    private var dataLoadResultSubscription: Cancellable?
    
    init(viewModel: GalleryViewOutput) {
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
        navigationItem.title = "MobileUp Gallery"

        setupCollectionView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataLoadResultSubscription?.cancel()
    }
    
    // MARK: - UI Setup
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Combine
    
    private func bindViewModel() {
        dataLoadResultSubscription = viewModel.dataLoadResultPublisher?
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            })
    }

}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
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

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSide = (collectionView.frame.width - Constants.interitemSpacing) / 2
        return CGSize(width: cellSide, height: cellSide)
    }
}

// MARK: - Constants

extension GalleryViewController {
    private struct Constants {
        static let interitemSpacing: CGFloat = 2
        static let lineSpacing: CGFloat = 3
    }
}
