//
//  EliminacionClienteController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 13/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class EliminacionClienteController: UIViewController {
    
    
    var styleAzul = ToastStilo()
    
    
    @IBOutlet weak var btnBorrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
    }
    
    
    
    
    @IBAction func btnAccionBorrar(_ sender: Any) {
        
        verificar()
    }
    
    
    func verificar(){
        
        let alert = UIAlertController(title: "Eliminar Cuenta", message:"Esto eliminara todos tus Datos Personales de la Aplicación", preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si Eliminar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              self.peticionEliminarCuenta()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionEliminarCuenta(){
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiEliminarCuentaCliente
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      // CLIENTE ELIMINADO
                      
                      self.alertaCuentaBorrada()
                      
                     
                  }
                  else{
                      self.mensajeSinConexion()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.mensajeSinConexion()
              }
        }
        
    }
    
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func alertaCuentaBorrada(){
        
        let alert = UIAlertController(title: "Cuenta Eliminada", message:"Todos tus Datos Personales de la Aplicación han sido Eliminados", preferredStyle: UIAlertController.Style.alert)
                              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.salir()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func salir(){
        
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
}
