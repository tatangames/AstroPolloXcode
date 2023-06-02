//
//  CategoryCollectionViewCell.swift
//  Yummie
//
//  Created by Emmanuel Okwara on 20/02/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    func setup(category: ModeloCategoriasPrincipal) {
        categoryTitleLbl.text = category.getNombre()
        
        
        let union = baseUrlImagen + category.getImagen()
                   
        categoryImageView.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
        
    }
}
