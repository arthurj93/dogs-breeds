//
//  ListBreedCell.swift
//  dogsBreed
//
//  Created by Arthur Jatoba on 12/02/19.
//  Copyright © 2019 Arthur Jatoba. All rights reserved.
//

import UIKit

class ListBreedCell: UICollectionViewCell {
    
    enum Constanst {
        static let cornerRadius:CGFloat = 5
    }
    
    static let cellId = "ListBreedCell"

    @IBOutlet weak var nameBreedCell: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func setup(name: String) {
        nameBreedCell.text = name.capitalized
        nameBreedCell.textColor = .white
        containerView.layer.cornerRadius = Constanst.cornerRadius
        containerView.backgroundColor = #colorLiteral(red: 0.8378465772, green: 0.8386424184, blue: 0.7956578135, alpha: 1)
    }

}
