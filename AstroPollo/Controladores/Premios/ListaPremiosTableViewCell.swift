//
//  ListaPremiosTableViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 9/6/23.
//

import UIKit



protocol TableViewBotonPremio {
    func onClickCellPremio(index: Int)
}

class ListaPremiosTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtPremio: UILabel!
    @IBOutlet weak var txtPuntos: UILabel!    
    @IBOutlet weak var imgCheck: UIImageView!
    
    
    @IBOutlet weak var btnSeleccionar: UIButton!
    
    var cellDelegatePremio: TableViewBotonPremio?
    
    var index: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPremio(_ sender: Any) {
        cellDelegatePremio?.onClickCellPremio(index: (index?.row)!)
    }
    
}
