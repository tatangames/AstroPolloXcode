//
//  ListaPremiosTableViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 9/6/23.
//

import UIKit

class ListaPremiosTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtPremio: UILabel!
    @IBOutlet weak var txtPuntos: UILabel!    
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
