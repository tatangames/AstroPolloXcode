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
    
    
    @IBAction func btnBorrar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Borrar dirección", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.peticionBorrarDireccion()
        }))
                  
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func peticionBorrarDireccion(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        let idCliente = "3"
        
        let params = [
            "id": idCliente,
            "dirid": String(iddireccion)
        ]
        
        let encodeURL = apiBorrarDireccion
        
          AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                               
               switch response.result{
                 case .success(let value):
                     
                     MBProgressHUD.hide(for: self.view, animated: true)
                                                    
                     let json = JSON(value)
                     
                     let codigo = json["success"]
                     
                      if(codigo == 1){
                       
                          // DIRECCION BORRADA
                          
                         self.alertaDireccionBorrada()
                     } else if(codigo == 2){
                        
                         // SE REQUIERE MINIMO 1 DIRECCION
                         
                         self.alerta1Direccion()
                     }
                     else{
                         MBProgressHUD.hide(for: self.view, animated: true)
                         self.mensajeSinConexion()
                     }
           
                 case .failure( _):
                     MBProgressHUD.hide(for: self.view, animated: true)
                     self.retryPeticionBorrarDireccion()
                 }
           }
    }
    
    func retryPeticionBorrarDireccion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBorrarDireccion()
    }
    
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    func alertaDireccionBorrada(){
        
        let alert = UIAlertController(title: "Borrado", message: "La dirección se elimino correctamente", preferredStyle: UIAlertController.Style.alert)
                              
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.salir()
        }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
  
    
    func salir(){
        self.recargarVistaAnterior = true
        dismiss(animated: true, completion: nil)
    }
    
    
    func alerta1Direccion(){
        
        let alert = UIAlertController(title: "Nota", message: "Se requiere mínimo 1 dirección", preferredStyle: UIAlertController.Style.alert)
                              
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func btnAccionSeleccionar(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Seleccionar", message: "Esta sera su dirección de entrega", preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              self.peticionSeleccionar()
             }))
              
             self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func peticionSeleccionar(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        let idCliente = "3"
        
        let params = [
            "id": idCliente,
            "dirid": String(iddireccion)
        ]
        
        let encodeURL = apiSeleccionarDireccion
        
          AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                               
               switch response.result{
                 case .success(let value):
                     
                     MBProgressHUD.hide(for: self.view, animated: true)
                                                    
                     let json = JSON(value)
                     
                     let codigo = json["success"]
                     
                      if(codigo == 1){
                          
                          // DIRECCION SELECCIONADA
                          
                          self.alertaDireccionSeleccionada()
                       
                     }
                     else{
                         MBProgressHUD.hide(for: self.view, animated: true)
                         self.mensajeSinConexion()
                     }
           
                 case .failure( _):
                     MBProgressHUD.hide(for: self.view, animated: true)
                     self.retryPeticionSeleccionar()
                 }
           }
        
        
    }
    
    
    func retryPeticionSeleccionar(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionSeleccionar()
    }
    
    
    func alertaDireccionSeleccionada(){
        
        
        let alert = UIAlertController(title: "Actualizado", message: "", preferredStyle: UIAlertController.Style.alert)
                              
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.salir()
        }))
              
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var delegate: protocolRecargarVista!
   
    // pasar un bool para recargar pagina atras
    override func viewWillDisappear(_ animated: Bool) {
       delegate.pass(data: recargarVistaAnterior)
    }
    
}
