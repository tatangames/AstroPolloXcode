//
//  ProductoPoCollectionViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 2/6/23.
//

import UIKit

class ProductoPoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ProductoPoCollectionViewCell.self)

    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var vista: CardView!
    
    func setup(producto: ModeloProductoPopular) {
        txtNombre.text = producto.getNombre()
        
        txtPrecio.text = producto.getPrecio()
                
        let union = baseUrlImagen + producto.getImagen()
                   
        imgProducto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
        
    }
}
