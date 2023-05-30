//
//  ListaProductosTableViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import UIKit

class ListaProductosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var txtDescripcion: UILabel!
    
    @IBOutlet weak var txtPrecio: UILabel!
    
    @IBOutlet weak var imgFoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
