//
//  ListBreedsCollectionViewController.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListBreedsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let network = APIManager.shared()
    
    enum Constants {
        static let cellHeight: CGFloat = 50
        static let lineSpacing: CGFloat = 5
        static let padding: CGFloat = 32
        static let collectionViewTopPadding: CGFloat = 16
    }
    
    var breedList: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        collectionView.register(UINib(nibName: ListBreedCell.cellId, bundle: nil), forCellWithReuseIdentifier: ListBreedCell.cellId)
        getListBreed()
        collectionView?.contentInset = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = .init(top: Constants.collectionViewTopPadding, left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
        setupNavigationBar(title: AppStrings.common_app_name, titleColor: #colorLiteral(red: 0.2052696645, green: 0.2191743255, blue: 0.23270455, alpha: 1), barTintColor: #colorLiteral(red: 0.8413519263, green: 0.8386471868, blue: 0.7956568599, alpha: 1))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListBreedCell.cellId, for: indexPath) as! ListBreedCell
    
        cell.setup(name: breedList[indexPath.item])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Constants.padding, height: Constants.cellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breedName = breedList[indexPath.item]
        let layout = UICollectionViewFlowLayout()
        let breedImageController = BreedImagesCollectionViewController(collectionViewLayout: layout,
                                                                       breedName: breedName)
        
        self.navigationController?.pushViewController(breedImageController, animated: true)
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineSpacing
    }
    
}

extension ListBreedsCollectionViewController: handleErrorAPI {
    
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
                showError("erro loco", message: response.message)
            }
            
        case .notConnectedToInternet:
            print("error de internet")
            showError(AppStrings.common_alert_error_title, message: AppStrings.apiError_noInternetConnection)
            
        case let .http(error):
            log("Unhandled error: \(error.localizedDescription)", event: .error)
        }
    }
    
    func validaFieldWithWebServiceErrors(_ error: Network.ErrorResponse.Item) {
        print(error.messages.first)
    }
    
    
    func getListBreed() {
        startAnimating()
        network.request(API.Breed.getBreeds()) { (listBreed: [String]?, error: Error?) in
            if let error = error{
                self.handleError(error)
            }
            
            if let list = listBreed {
                self.breedList = list
                
            }
            self.stopAnimating()
        }
    }
}
