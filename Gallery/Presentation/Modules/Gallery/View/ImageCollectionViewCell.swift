//
//  ImageCollectionViewCell.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var placeholder: UIImage? = UIImage(systemName: "photo")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = placeholder
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.image = placeholder
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

extension ImageCollectionViewCell: Configurable {
    
    typealias ConfigurationModel = UIImage
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
}
