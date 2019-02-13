//
//  BrreedImageCell.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit
import SDWebImage

class BreedImageCell: UICollectionViewCell {
    
    enum Constants {
        static let cornerRadius: CGFloat = 5
    }
    
    static let cellId = "BreedImageCell"
    
    var breedImage: String? {
        didSet {
            guard let url = URL(string: breedImage ?? "") else { return}
            breedImageView.sd_setImage(with: url)
        }
    }
    
    let breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(breedImageView)
        breedImageView.anchor(top: safeAreaLayoutGuide.topAnchor,
                              leading: safeAreaLayoutGuide.leadingAnchor,
                              bottom: safeAreaLayoutGuide.bottomAnchor,
                              trailing: safeAreaLayoutGuide.trailingAnchor)
    }
    
}
