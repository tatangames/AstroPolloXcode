//
//  SeleccionarDireccionController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class SeleccionarDireccionController: UIViewController {
    
    
    var styleAzul = ToastStyle()
    var nombre = ""
    var direccion = ""
    var referencia = ""
    var telefono = ""
    var iddireccion = 0
    
    var recargarVistaAnterior = false
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var txtDireccion: UILabel!
    
    @IBOutlet weak var txtReferencia: UILabel!
    
    @IBOutlet weak var txtTelefono: UILabel!
    
    @IBOutlet weak var btnSeleccionar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        txtNombre.text = nombre
        txtDireccion.text = direccion
        txtReferencia.text = referencia
        txtTelefono.text = telefono
        
        self.btnSeleccionar.layer.cornerRadius = 18
        self.btnSeleccionar.clipsToBounds = true
        
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 20, bottom: 40, right: 20)
        
        
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
       
    }
    
    
    
    
    var delegate: protocolRecargarVista!
   
    // pasar un bool para que no recargue el carrito de compras la pantalla
    override func viewWillDisappear(_ animated: Bool) {
       delegate.pass(data: recargarVistaAnterior)
    }
    
}
