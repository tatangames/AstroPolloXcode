//
//  PerfilViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit

class PerfilViewCell: UITableViewCell {
       
   
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var textoPerfil: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
