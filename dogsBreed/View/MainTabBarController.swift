//
//  ViewController.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()

    }
    
    func setupNavBar() {
        
        let layoutList = UICollectionViewFlowLayout()
        let listBreedController = templateNavController(imageTitle: AppStrings.tabBar_home_title,
                                                        image: #imageLiteral(resourceName: "home-selected").withRenderingMode(.alwaysTemplate),
                                                        rootViewController: ListBreedsCollectionViewController(collectionViewLayout: layoutList))
        
        let layoutFavorite = UICollectionViewFlowLayout()
        let favoritesController = templateNavController(imageTitle: AppStrings.tabBar_favorites_title,
                                                          image: #imageLiteral(resourceName: "start-selected").withRenderingMode(.alwaysTemplate),
                                                          rootViewController: FavoritesBreedsCollectionViewController(collectionViewLayout: layoutFavorite))
        
        
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
                          NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributesSelected = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
                                  NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1675502956, green: 0.5672884583, blue: 0.9695023894, alpha: 1) ] as [NSAttributedString.Key : Any]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        self.tabBar.barTintColor = #colorLiteral(red: 0.8413519263, green: 0.8386471868, blue: 0.7956568599, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 0.1675502956, green: 0.5672884583, blue: 0.9695023894, alpha: 1)
        self.tabBar.unselectedItemTintColor = .white
        
        viewControllers = [
            listBreedController,
            favoritesController
        ]
    }
    
    private func templateNavController(imageTitle: String,
                                       image: UIImage,
                                       rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = image
        navController.tabBarItem.title = imageTitle
        
        return navController
    }


}

