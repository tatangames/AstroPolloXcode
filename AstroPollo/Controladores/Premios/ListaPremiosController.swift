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






class ListaPremiosController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewBotonPremio{
   
    
    
    func onClickCellPremio(index: Int) {
        let datoFila = arrPremios[index]
       
        if(datoFila.getSeleccionado() == 1){
            alertaBorrar()
        }else{
            alertaSeleccion(idpremio: datoFila.getId())
        }
    }
  
    
    var styleAzul = ToastStilo()
    
    
    @IBOutlet weak var textoPremio: UILabel!
    @IBOutlet weak var txtPuntos: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var stackVista: UIStackView!
    
    
    
    var arrPremios = [ModelosPremio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
                
        // ocultar lineas vacias
        tableView.tableFooterView = UIView()
        peticionBuscarPremios()
        
    }
    
    
    func peticionBuscarPremios(){
        
        arrPremios.removeAll()
        tableView.reloadData()
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiListadoPremios
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                                           
                      let conteo = json["conteo"].intValue
                      let nota = json["nota"].stringValue
                      let puntos = json["puntos"].stringValue
                                            
                      self.textoPremio.text = nota
                      self.txtPuntos.text = puntos
                           
                      
                      json["listado"].array?.forEach({ (dataArray) in
                                                       
                          let id = dataArray["id"].intValue
                          let nombre = dataArray["nombre"].stringValue
                          let puntos = dataArray["puntos"].intValue
                          let activo = dataArray["activo"].intValue
                          let seleccionado = dataArray["seleccionado"].intValue
                      
                                                                      
                          self.arrPremios.append(ModelosPremio(id: id, nombre: nombre, puntos: puntos, activo: activo, seleccionado: seleccionado))
                      })
                        
                      
                      if(conteo == 0){
                          self.sinPremios()
                      }
                      
                        
                        self.stackVista.isHidden = false
                        self.tableView.reloadData()
                  }
                
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionBuscarPremios()
              }
        }
    }
    
    func sinPremios(){
        self.view.makeToast("No hay Premios", duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    func retryPeticionBuscarPremios(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarPremios()
    }
        
    
    
    @IBAction func btnAtras(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func alertaBorrar(){
        
        let alert = UIAlertController(title: "Borrar Selección", message: nil, preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.peticionBorrarSeleccion()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
        
    func peticionBorrarSeleccion(){
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiBorrarPremioSeleccionado
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                   
                        // PREMIO SELECCIONADO BORRADO
                      
                      self.mensajeToastAzul(mensaje: "Actualizado")
                      self.peticionBuscarPremios()
                      
                  }
                
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.mensajeSinConexion()
              }
        }
    }
    
    
    func alertaSeleccion(idpremio: Int){
        
        
        let alert = UIAlertController(title: "Seleccionar Premio", message: nil, preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.peticionSeleccionarPremio(idpremio: idpremio)
             }))
              
             self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func peticionSeleccionarPremio(idpremio: Int){
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente,
            "idpremio": String(idpremio)
        ]
        
        let encodeURL = apiSeleccionarPremio
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                   
                        // PREMIO NO ESTA DISPONIBLE YA
                      
                      self.peticionBuscarPremios()
                      
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                      
                      self.alertaReglas(titulo: titulo, mensaje: mensaje)
                  }
                
                else if(codigo == 2){
                        
                    
                    // PUNTOS NO ALCANZAN
                    
                    
                    let titulo = json["titulo"].stringValue
                    let mensaje = json["mensaje"].stringValue
                    
                    self.alertaReglas(titulo: titulo, mensaje: mensaje)
                }
                    
                else if(codigo == 3){
                    
                    // PREMIO SELECCIONADO
                    
                    
                    self.peticionBuscarPremios()
                    
                    let titulo = json["titulo"].stringValue
                    let mensaje = json["mensaje"].stringValue
                    
                    self.alertaReglas(titulo: titulo, mensaje: mensaje)
                }
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.mensajeSinConexion()
              }
        }
        
    }
    
    
    
    func alertaReglas(titulo: String, mensaje: String){
        
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
            
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 
             }))
              
             self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrPremios.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListaPremiosTableViewCell
           
        let datos = arrPremios[indexPath.row]
        
        
        cell.txtPremio.text = datos.getNombre()
        cell.txtPuntos.text = "Puntos: " + String(datos.getPuntos())
        
        if(datos.getSeleccionado() == 1){
            
            cell.btnSeleccionar.setTitle("Borrar Selección", for: .normal)
            cell.btnSeleccionar.backgroundColor = UIColor(named: "ColorRojo")
            
            cell.imgCheck.isHidden = false
        }else{
            cell.imgCheck.isHidden = true
            
            cell.btnSeleccionar.setTitle("Seleccionar", for: .normal)
            cell.btnSeleccionar.backgroundColor = UIColor(named: "ColorVerde")
        }
        cell.btnSeleccionar.layer.cornerRadius = 10
        cell.btnSeleccionar.clipsToBounds = true
        cell.index = indexPath
        cell.cellDelegatePremio = self
                                
        cell.selectionStyle = .none
                          
        return cell
    }
    
    

    
    
    
    
    
}
    
