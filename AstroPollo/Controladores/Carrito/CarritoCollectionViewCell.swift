//
//  CarritoCollectionViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 3/6/23.
//

import UIKit

class CarritoCollectionViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var txtCantidad: UILabel!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var vistaCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    
    
    
}
