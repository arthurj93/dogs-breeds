//
//  FavoriteImages.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 13/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class FavoriteImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    enum Constants {
        static let widthDivisor: CGFloat = 3
        static let padding: CGFloat = 2
        static let itemSpacing: CGFloat = 0
        static let lineSpacing: CGFloat = 2
        static let countImagesLimit = 4
    }
    
    let breedRealm = BreedDataImplementation.shared()
    
    var breedStrings: [String] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let breedName: String
    
    init(collectionViewLayout layout: UICollectionViewLayout,
         breedName: String,
         breedStrings: [String]) {
        self.breedName = breedName
        self.breedStrings = breedStrings
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(BreedImageCell.self, forCellWithReuseIdentifier: BreedImageCell.cellId)
        collectionView?.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        
        setupNavigationBar(title: breedName.capitalized, titleColor: #colorLiteral(red: 0.2052696645, green: 0.2191743255, blue: 0.23270455, alpha: 1), barTintColor: #colorLiteral(red: 0.8413519263, green: 0.8386471868, blue: 0.7956568599, alpha: 1))
        setupNavigationBarButton(breedName: breedName.capitalized, selector: #selector(checkFavorite))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedStrings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCell.cellId, for: indexPath) as! BreedImageCell
        
        cell.breedImage = breedStrings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/Constants.widthDivisor - Constants.padding, height: view.frame.width/Constants.widthDivisor - Constants.padding)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineSpacing
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = breedStrings[indexPath.item]
        let breedImageDetailController = BreedImageDetailViewController()
        breedImageDetailController.breedImage = url
        self.navigationController?.pushViewController(breedImageDetailController, animated: true)
    }
    
}

extension FavoriteImagesCollectionViewController: BreedDataForVC {
    func getBreedByName() -> Breeds {
        let breed = breedRealm.getBreedBy(name: breedName)
        
        return breed
    }
    
    func save() {
        var images = [String]()
        
        for (index, image) in breedStrings.enumerated() {
            if index <= Constants.countImagesLimit {
                images.append(image)
            }
        }
        
        breedRealm.save(name: breedName, images: images)
    }
    
    func getAllBreeds() -> [Breeds] {
        return breedRealm.getAllBreeds()
    }
    
    func deleteBreed() {
        breedRealm.deleteBreed(name: breedName)
    }
    
    @objc func checkFavorite() {
        startAnimating()
        let breed = getBreedByName()
        
        if breed.name == nil {
            save()
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "start-selected").withRenderingMode(.alwaysTemplate)
        } else {
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "star-unselected").withRenderingMode(.alwaysTemplate)
            deleteBreed()
        }
        stopAnimating()
    }
}
