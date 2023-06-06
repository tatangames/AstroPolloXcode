//
//  OrdenesViewController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import Foundation


import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

protocol protocoloEstadoOrden {
  func pasarEstadoOrden(data: Bool)
}

class OrdenesViewController: UIViewController, UITableViewDelegate,
                             UITableViewDataSource, protocoloEstadoOrden {
    
    
    func pasarEstadoOrden(data: Bool) {
       
        if(data){
            peticionBuscarOrdenes()
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
        
    var styleAzul = ToastStilo()
    var arrOrdenes = [ModeloOrdenes]()
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "ColorAzulToast")
        
        tableView.tableFooterView = UIView()
        
        peticionBuscarOrdenes()
    }
    
    
    var booleanTouchBoton = false
    
    func recargarTouchBoton(){
        
        if(booleanTouchBoton){
            peticionBuscarOrdenes()
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        peticionBuscarOrdenes()
    }
    
    
    func peticionBuscarOrdenes(){
        
        arrOrdenes.removeAll()
        tableView.reloadData()
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiVerListadoOrdenes
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                
                self.booleanTouchBoton = true
                self.refreshControl.endRefreshing()
                
                if(codigo == 1){
                    
                   // LISTADO
                                        
                    
                    json["ordenes"].array?.forEach({ (dataArray) in
                        
                        let id = dataArray["id"].intValue
                        let notaOrden = dataArray["nota_orden"].stringValue
                        let total = dataArray["totalformat"].stringValue
                        let fecha = dataArray["fecha_orden"].stringValue
                        let notaCancelada = dataArray["nota_cancelada"].stringValue
                        let mensajeCupon = dataArray["mensaje_cupon"].stringValue
                        let direccion = dataArray["direccion"].stringValue
                        let estado = dataArray["estado"].stringValue
                        
                        let estadoCancelada = dataArray["estado_cancelada"].intValue
                        let hayCupon = dataArray["haycupon"].intValue

                        
                        self.arrOrdenes.append(ModeloOrdenes(idOrden: id, notaOrden: notaOrden, totalFormat: total, fechaOrden: fecha, notaCancelada: notaCancelada, mensajeCupon: mensajeCupon, direccion: direccion, estado: estado, estadoCancelada: estadoCancelada, hayCupon: hayCupon))
                    })
                    
                    
                    if(self.arrOrdenes.count == 0){
                        self.mensajeToastAzul(mensaje: "Ordenes vacía")
                    }
                                        
                  
                    self.tableView.reloadData()
                }
               
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryPeticionBuscarOrdenes()
            }
        }
    }
    
    
    func retryPeticionBuscarOrdenes(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarOrdenes()
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
                
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return arrOrdenes.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OrdenesTableViewCell
       
        let datos = arrOrdenes[indexPath.row]
                          
        cell.txtNumOrden.text = "Orden #: \(datos.getIdOrden())"
        cell.txtDireccion.text = "Dirección: \(datos.getDireccion())"
        cell.txtTotalPagar.text = "Total a Pagar: \(datos.getTotalOrden())"
        cell.txtFecha.text = "Fecha: \(datos.getFechaOrden())"
        cell.txtEstado.text = "Estado: \(datos.getEstado())"
        
        
        if(datos.getEstadoCancelada() == 1){
            
            if(!datos.getNotaCancelada().isEmpty){
                cell.txtNotaCancelada.text = "Nota: " + datos.getNotaCancelada()
                cell.txtNotaCancelada.isHidden = false
            }
            else{
                cell.txtNotaCancelada.isHidden = true
            }
            
        }else{
            cell.txtNotaCancelada.isHidden = true
            
        }
        
        
        // CUPONES
        if(datos.getHayCupon() == 1){
            
            if(!datos.getMensajeCupon().isEmpty){
                cell.txtCupon.text = "Cupón: " + datos.getMensajeCupon()
                cell.txtCupon.isHidden = false
                
            }else{
                cell.txtCupon.isHidden = true
            }
            
        }else{
            cell.txtCupon.isHidden = true
        }
        
        
        if(!datos.getNotaOrden().isEmpty){
            cell.txtNota.text = "Nota: " + datos.getNotaOrden()
            cell.txtNota.isHidden = false
        }else{
            cell.txtNota.isHidden = true
        }
        
        
        
        // PREMIOS
        cell.txtPremio.isHidden = true
              
       cell.selectionStyle = .none
          
       return cell
   }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          let datos = arrOrdenes[indexPath.row]
          
          
          let vista : EstadoOrdenController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EstadoOrdenController") as! EstadoOrdenController
       
          vista.idorden = datos.getIdOrden()
          vista.delegateEstadoOrden = self
          
          self.present(vista, animated: true, completion: nil)
      }

    
    
    
    
    
    
    
    
    
}
