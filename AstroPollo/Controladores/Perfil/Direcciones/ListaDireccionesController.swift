//
//  ListaDireccionesController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire


protocol protocolRecargarVista {
  func pass(data: Bool)
}


class ListaDireccionesController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolRecargarVista{
    
 
    func pass(data: Bool) {
        if(data){
            arr.removeAll()
            tableView.reloadData()
            
            peticionBuscarDirecciones()
        }
    }
    
    
    @IBOutlet weak var btnAgregarDireccion: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var styleAzul = ToastStilo()
    
    var arr = [ModeloDirecciones]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        // ocultar lineas vacias
        tableView.tableFooterView = UIView()
        peticionBuscarDirecciones()
    }
    
    
    func peticionBuscarDirecciones(){
        
        //let idClienteusuario = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        let idCliente = "3"
        
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
    
    func alertaSinDirecciones(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
             
             }))
              
             self.present(alert, animated: true, completion: nil)
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
    
    
    
    
    @IBAction func btnAccionAddDireccion(_ sender: Any) {
        
        
        let vista : MapaDireccionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapaDireccionController") as! MapaDireccionController
               
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arr.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cellReuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ListaDireccionesViewCell
           
        let datos = arr[indexPath.row]
        
        
        cell.txtNombre.text = datos.getNombre()
        cell.txtDireccion.text = datos.getDireccion()
        
        if(datos.getSeleccionado() == 1){
            cell.imgCheck.isHidden = false
        }else{
            cell.imgCheck.isHidden = true
        }
                            
       cell.selectionStyle = .none
                          
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = arr[indexPath.row]
        
        let nombre = datos.getNombre()
        let direccion = datos.getDireccion()
        let referencia = datos.getPuntoReferencia()
        let telefono = datos.getTelefono()
        let iddireccion = datos.getId()
        
        let vista : SeleccionarDireccionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SeleccionarDireccionController") as! SeleccionarDireccionController
        vista.nombre = nombre
        vista.direccion = direccion
        vista.referencia = referencia
        vista.telefono = telefono
        vista.iddireccion = iddireccion
        vista.delegate = self
        
        self.present(vista, animated: true, completion: nil)
    }

    
    
    
    
}
