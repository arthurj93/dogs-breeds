//
//  BreedImagesCollectionViewController.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RealmSwift

class BreedImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {

    enum Constants {
        static let widthDivisor: CGFloat = 3
        static let padding: CGFloat = 2
        static let itemSpacing: CGFloat = 0
        static let lineSpacing: CGFloat = 2
        static let countImagesLimit = 4
        static let cellCount = 1
        static let paddingListCell: CGFloat = 32
        static let cellHeight: CGFloat = 50
        static let collectionViewTopPadding: CGFloat = 16
    }
    
    let network = APIManager.shared()
    let breedRealm = BreedDataImplementation.shared()
    
    var breedStrings: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let breedName: String
    
    init(collectionViewLayout layout: UICollectionViewLayout,
         breedName: String) {
        self.breedName = breedName
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(BreedImageCell.self, forCellWithReuseIdentifier: BreedImageCell.cellId)
        self.collectionView.register(UINib(nibName: ListBreedCell.cellId, bundle: nil), forCellWithReuseIdentifier: ListBreedCell.cellId)
        
        collectionView?.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        collectionView?.contentInset = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        
        setupNavigationBar(title: breedName.capitalized, titleColor: #colorLiteral(red: 0.2052696645, green: 0.2191743255, blue: 0.23270455, alpha: 1), barTintColor: #colorLiteral(red: 0.8413519263, green: 0.8386471868, blue: 0.7956568599, alpha: 1))
        setupNavigationBarButton(breedName: breedName.capitalized, selector: #selector(checkFavorite))
        getImages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if breedStrings.count == 0 {
            return Constants.cellCount
        }
        
        return breedStrings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if breedStrings.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListBreedCell.cellId, for: indexPath) as! ListBreedCell
            cell.setup(name: AppStrings.apiError_refresher)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCell.cellId, for: indexPath) as! BreedImageCell
        
        cell.breedImage = breedStrings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if breedStrings.count == 0 {
            return CGSize(width: collectionView.bounds.width - Constants.paddingListCell, height: Constants.cellHeight)
        }
        
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
        
        if breedStrings.count != 0 {
            let url = breedStrings[indexPath.item]
            let breedImageDetailController = BreedImageDetailViewController()
            breedImageDetailController.breedImage = url
            self.navigationController?.pushViewController(breedImageDetailController, animated: true)
            return
        }
        
        getImages()
    }
    
}

extension BreedImagesCollectionViewController: BreedDataForVC {
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
    
    @objc func getImages() {
        getImagesBy(breed: breedName)
    }
}

extension BreedImagesCollectionViewController: handleErrorAPI {
    
    func handleError(_ error: Error) {
        guard let err = error as? Network.Error else {
            log("Unhandled error: \(error.localizedDescription)", event: .error)
            return
        }
        
        switch err {
        case let .api(_, response):
            if response.errors.isEmpty == false {
                response.errors.forEach(validaFieldWithWebServiceErrors(_:))
            } else {
                print(response.message)
                showError(AppStrings.common_alert_warning_title, message: response.message)
            }
            
        case .notConnectedToInternet:
            showError(AppStrings.common_alert_error_title, message: AppStrings.apiError_noInternetConnection)
            
        case let .http(error):
            showError(AppStrings.common_alert_error_title, message: error.localizedDescription)
            log("Unhandled error: \(error.localizedDescription)", event: .error)
        }
    }
    
    func validaFieldWithWebServiceErrors(_ error: Network.ErrorResponse.Item) {
        print(error.messages.first)
    }
    
    func getImagesBy(breed: String) {
        startAnimating()
        network.request(API.Breed.getImages(breed: breed)) { (images: [String]?, error: Error?) in
            if let error = error{
                self.handleError(error)
            }
            
            if let breedImages = images {
                self.breedStrings = breedImages
                
            }
            self.stopAnimating()
        }
    }
}
