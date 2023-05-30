//
//  ListaDireccionesViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit

class ListaDireccionesViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtNombre: UILabel!    
    @IBOutlet weak var txtDireccion: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
