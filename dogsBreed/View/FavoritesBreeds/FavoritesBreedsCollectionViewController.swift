//
//  FavoritesBreedsCollectionViewController.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FavoritesBreedsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let breedRealm = BreedDataImplementation.shared()
    
    enum Constants {
        static let cellHeight: CGFloat = 50
        static let lineSpacing: CGFloat = 5
        static let padding: CGFloat = 32
        static let collectionViewTopPadding: CGFloat = 16
        static let cellCount = 1
    }
    
    var breedList: [Breeds] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        collectionView.register(UINib(nibName: ListBreedCell.cellId, bundle: nil), forCellWithReuseIdentifier: ListBreedCell.cellId)
        collectionView?.contentInset = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
        setupNavigationBar(title: AppStrings.common_favorites_title, titleColor: #colorLiteral(red: 0.2052696645, green: 0.2191743255, blue: 0.23270455, alpha: 1), barTintColor: #colorLiteral(red: 0.8413519263, green: 0.8386471868, blue: 0.7956568599, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        breedList = getAllBreeds()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if breedList.count == 0 {
            return Constants.cellCount
        }
        
        return breedList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListBreedCell.cellId, for: indexPath) as! ListBreedCell
        
        if breedList.count == 0 {
            cell.setup(name: AppStrings.common_no_favortes)
        } else {
           cell.setup(name: breedList[indexPath.item].name ?? "")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if breedList.count != 0 {
            let breedName = breedList[indexPath.item]
            let layout = UICollectionViewFlowLayout()
            let breedImageController = FavoriteImagesCollectionViewController(collectionViewLayout: layout,
                                                                              breedName: breedName.name ?? "",
                                                                              breedStrings: breedName.images ?? [""])
            
            self.navigationController?.pushViewController(breedImageController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Constants.padding, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineSpacing
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
}

extension FavoritesBreedsCollectionViewController: BreedDataForVC {
    func getBreedByName() -> Breeds {
        return Breeds()
    }
    
    func save() {
    }
    
    func getAllBreeds() -> [Breeds] {
        return breedRealm.getAllBreeds()
    }
    
    func deleteBreed() {
        
    }

}

