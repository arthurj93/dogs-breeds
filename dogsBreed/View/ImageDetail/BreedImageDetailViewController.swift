//
//  BreedImageDetailViewController.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit

class BreedImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    enum Constants {
        static let minZoom: CGFloat = 1
        static let maxZoom: CGFloat = 10
        static let zoomScale: CGFloat = 1
    }
    
    var breedImage: String = "" {
        didSet {
            let url = URL(string: breedImage)
            breedImageView.sd_setImage(with: url)
        }
    }
    
    lazy var breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = Constants.minZoom
        scrollView.maximumZoomScale = Constants.maxZoom
        return scrollView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9176028371, green: 0.908431828, blue: 0.7742337584, alpha: 1)
        scrollView.delegate = self
        setupView()
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        scrollView.addSubview(breedImageView)
        breedImageView.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              bottom: scrollView.bottomAnchor,
                              trailing: scrollView.trailingAnchor)
        breedImageView.anchorSize(to: scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return breedImageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.zoomScale = Constants.zoomScale
    }
}
