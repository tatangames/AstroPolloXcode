//
//  OrdenesTableViewCell.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 5/6/23.
//

import UIKit


protocol TableViewBotonEstado {
    func onClickCellEstado(index: Int)
}

class OrdenesTableViewCell: UITableViewCell {

    @IBOutlet weak var txtNumOrden: UILabel!
    @IBOutlet weak var txtDireccion: UILabel!
    @IBOutlet weak var txtEstado: UILabel!
    @IBOutlet weak var txtTotalPagar: UILabel!
    @IBOutlet weak var txtCupon: UILabel!
    @IBOutlet weak var txtPremio: UILabel!
    @IBOutlet weak var txtFecha: UILabel!
    @IBOutlet weak var txtNotaCancelada: UILabel!
    @IBOutlet weak var txtNota: UILabel!    
    
    
    
    @IBOutlet weak var btnEstado: UIButton!
    
    var cellDelegateEstado: TableViewBotonEstado?
    
    var index: IndexPath?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnAccionEstado(_ sender: Any) {
        cellDelegateEstado?.onClickCellEstado(index: (index?.row)!)
    }
    
    

}
