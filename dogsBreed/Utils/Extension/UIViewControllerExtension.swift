//
//  UIViewControllerExtension.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func setupNavigationBarButton(breedName: String, selector: Selector) {
        
        var favoriteButton = UIBarButtonItem()
        
        let breed = BreedDataImplementation.shared().getBreedBy(name: breedName.lowercased())
        
        if  breed.name == nil {
            favoriteButton = UIBarButtonItem(image:#imageLiteral(resourceName: "star-unselected").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: selector)
        } else {
            favoriteButton = UIBarButtonItem(image:#imageLiteral(resourceName: "start-selected").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: selector)
        }

        self.navigationItem.rightBarButtonItem = favoriteButton
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func showError(_ title: String?, message: String?) {
        UIAlertController.presentAlert(
            in: self,
            title: title,
            message: message,
            actions: [UIAlertAction(title: AppStrings.common_ok, style: .default, handler: nil)]
        )
    }
    
    func setupNavigationBar(title: String?, titleColor: UIColor, barTintColor: UIColor) {
        self.navigationItem.title = title
        navigationController?.navigationBar.barTintColor = barTintColor
        navigationController?.navigationBar.isTranslucent = false
        let attributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
}
