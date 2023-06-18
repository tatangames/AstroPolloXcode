//
//  HistorialBusquedaController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 18/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire


class HistorialBusquedaController: UIViewController, UITableViewDelegate,
                                   UITableViewDataSource,
          TableViewBotonEstadoHistorial {
    
  
    
    var fechaDesde = ""
    var fechaHasta = ""
   
    var styleAzul = ToastStilo()
    var arrOrdenes = [ModeloOrdenes]()
    
    func onClickCellEstado(index: Int) {
        let datoFila = arrOrdenes[index]
       
     
        let vista : ProductosOrdenController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductosOrdenController") as! ProductosOrdenController
     
        vista.idorden = datoFila.getIdOrden()
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
      
        tableView.tableFooterView = UIView()
        
        peticionBuscar()
    }
    
    
    func peticionBuscar(){
        
        arrOrdenes.removeAll()
        tableView.reloadData()
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente,
            "fecha1": fechaDesde,
            "fecha2": fechaHasta
        ]
        
        let encodeURL = apiBuscarHistorial
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                
                
                if(codigo == 1){
                    
                   // LISTADO
                    
                    let conteo = json["hayordenes"].intValue
                    
                    if(conteo == 0){
                        self.mensajeToastAzul(mensaje: "No hay Ordenes")
                    }
                                        
                    
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
                        
                        let hayPremio = dataArray["haypremio"].intValue
                        let textoPremio = dataArray["textopremio"].stringValue
                        
                        
                        self.arrOrdenes.append(ModeloOrdenes(idOrden: id, notaOrden: notaOrden, totalFormat: total, fechaOrden: fecha, notaCancelada: notaCancelada, mensajeCupon: mensajeCupon, direccion: direccion, estado: estado, estadoCancelada: estadoCancelada, hayCupon: hayCupon, hayPremio: hayPremio, textoPremio: textoPremio))
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
                self.retryPeticionBuscar()
            }
        }
        
    }
    
    
    
    
    func retryPeticionBuscar(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscar()
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
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return arrOrdenes.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistorialBusquedaTableViewCell
       
        let datos = arrOrdenes[indexPath.row]
                          
        cell.txtNumOrden.text = "Orden #: \(datos.getIdOrden())"
        cell.txtDireccion.text = "Dirección: \(datos.getDireccion())"
        cell.txtTotalPagar.text = "Total a Pagar: \(datos.getTotalOrden())"
        cell.txtFecha.text = "Fecha: \(datos.getFechaOrden())"
        cell.txtEstado.text = "Estado: \(datos.getEstado())"
        
        
        if(datos.getEstadoCancelada() == 1){
            
            cell.txtEstado.textColor = .red
            
            
            
            if(!datos.getNotaCancelada().isEmpty){
                cell.txtNotaCancelada.text = "Nota: " + datos.getNotaCancelada()
                cell.txtNotaCancelada.isHidden = false
            }
            else{
                cell.txtNotaCancelada.isHidden = true
            }
            
        }else{
            cell.txtNotaCancelada.isHidden = true
            
            cell.txtEstado.textColor = .black
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
        
        
        cell.btnEstado.layer.cornerRadius = 10
        cell.btnEstado.clipsToBounds = true
        cell.index = indexPath
        cell.cellDelegateEstado = self
                                
              
        // PREMIOS
        if(datos.getHayPremio() == 1){
            
            if(!datos.getTextoPremio().isEmpty){
                cell.txtPremio.text = "Premio: " + datos.getTextoPremio()
                cell.txtPremio.isHidden = false
                
            }else{
                cell.txtPremio.isHidden = true
            }
            
        }else{
            cell.txtPremio.isHidden = true
        }
        
        
        
        let normalTitle = "PRODUCTOS"
        let normalAttributedTitle = NSAttributedString(string: normalTitle, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        cell.btnEstado.setAttributedTitle(normalAttributedTitle, for: .normal)
        
        
        // establecer el estilo bold para el estado resaltado
        
        let highlighedTitle = "PRODUCTOS"
        let highlightedAttributedTitle = NSAttributedString(string: highlighedTitle, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        cell.btnEstado.setAttributedTitle(highlightedAttributedTitle, for: .highlighted)
        
        
        cell.selectionStyle = .none
          
        return cell
   }
    
    
    
    
}
