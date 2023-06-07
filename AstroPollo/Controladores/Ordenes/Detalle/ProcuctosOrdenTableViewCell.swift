//
//  ProcuctosOrdenTableViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 6/6/23.
//

import UIKit

class ProcuctosOrdenTableViewCell: UITableViewCell {

    @IBOutlet weak var txtCantidad: UILabel!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var vistaCell: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
