//
//  ListaPremiosController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 9/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire



class ListaPremiosController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var styleAzul = ToastStilo()
    
    
    @IBOutlet weak var textoPremio: UILabel!
    @IBOutlet weak var txtPuntos: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
                
        // ocultar lineas vacias
        tableView.tableFooterView = UIView()
        peticionBuscarPremios()
    }
    
    func peticionBuscarPremios(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente
        ]
        
        let encodeURL = apiListadoDirecciones
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      self.btnAgregarDireccion.isHidden = false
                      
                      // SIN DIRECCIONES SE DEBE REGISTRAR UNA DIRECCION
                      
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                      
                      self.alertaSinDirecciones(titulo: titulo, mensaje: mensaje)
                  }
                
                else if(codigo == 2){
                   
                    
                    // LISTADO DE DIRECCIONES
                                                                          
                  json["direcciones"].array?.forEach({ (dataArray) in
                                                   
                      let id = dataArray["id"].intValue
                      let nombre = dataArray["nombre"].stringValue
                      let direccion = dataArray["direccion"].stringValue
                      
                      
                      var referencia = ""
                      if dataArray["punto_referencia"] == JSON.null {
                         // nada
                      }else{
                          referencia = dataArray["punto_referencia"].stringValue
                      }
                      
                      
                      let seleccionado = dataArray["seleccionado"].intValue
                      let telefono = dataArray["telefono"].stringValue
                                                                  
                      self.arr.append(ModeloDirecciones(id: id, nombre: nombre, direccion: direccion, punto_referencia: referencia, seleccionado: seleccionado, telefono: telefono))
                  })
                    
                    self.btnAgregarDireccion.isHidden = false
                    
                    
                    self.tableView.reloadData()
                }
                
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionBuscarDirecciones()
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
    
    
    func retryPeticionBuscarDirecciones(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarDirecciones()
    }
    
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}
    
