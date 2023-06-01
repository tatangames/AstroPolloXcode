//
//  CategoriaPrincipalCollectionViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 31/5/23.
//

import UIKit

import UIKit

class CategoriaPrincipalCollectionView: UICollectionViewCell {
    
    static let identifier = String(describing: CategoriaPrincipalCollectionView.self)

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    /*func setup(category: DishCategory) {
        categoryTitleLbl.text = category.name
        //categoryImageView.kf.setImage(with: category.image?.asUrl)
    }*/
}
