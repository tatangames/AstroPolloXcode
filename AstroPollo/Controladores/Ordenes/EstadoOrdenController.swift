//
//  EstadoOrdenController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 5/6/23.
//

import Foundation
import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class EstadoOrdenController: UIViewController{
    
    var idorden = 0
    var styleAzul = ToastStilo()
    var recargarVistaOrden = false
    
    
    @IBOutlet weak var txtNumOrden: UILabel!
    @IBOutlet weak var btnProducto: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    
    @IBOutlet weak var txtIniciada: UILabel!
    @IBOutlet weak var txtFechaIniciada: UILabel!
    @IBOutlet weak var circuloIniciada: UIImageView!
    
    
    @IBOutlet weak var txtEncamino: UILabel!
    @IBOutlet weak var txtFechaCamino: UILabel!
    @IBOutlet weak var btnMotorista: UIButton!
    @IBOutlet weak var circuloEncamino: UIImageView!
    
        
    @IBOutlet weak var circuloEntregada: UIImageView!
    @IBOutlet weak var txtEntregada: UILabel!
    @IBOutlet weak var txtFechaEntregada: UILabel!
    @IBOutlet weak var btnCompletar: UIButton!
    
    
    @IBOutlet weak var circuloCancelada: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var txtCancelado: UILabel!
    
    
    func salirAtras(){
        recargarVistaOrden = true
        dismiss(animated: true, completion: nil)
    }
    
    var refreshControl: UIRefreshControl!
    
    
    var boolOrdenCancelada = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        btnMotorista.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        
        btnProducto.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        
        btnCancelar.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        
        btnCompletar.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        
        
        
        btnMotorista.layer.cornerRadius = 10
        btnMotorista.clipsToBounds = true
        
        btnProducto.layer.cornerRadius = 10
        btnProducto.clipsToBounds = true
        
        btnCancelar.layer.cornerRadius = 10
        btnCancelar.clipsToBounds = true
        
        btnCompletar.layer.cornerRadius = 10
        btnCompletar.clipsToBounds = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
                
            
        peticionBuscarOrden()
    }
    
    @objc func refresh(){
        peticionBuscarOrden()
    }
    
    
    func peticionBuscarOrden(){
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "ordenid": String(idorden)
        ]
        
        let encodeURL = apiInforOrdenIndividual
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshControl.endRefreshing()
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                    
                    
                    json["ordenes"].array?.forEach({ (data1) in
                                              
                        self.txtNumOrden.text = "Orden #: \(self.idorden)"
                        self.txtIniciada.text = data1["textoiniciada"].stringValue
                        self.txtFechaIniciada.text = data1["fechaestimada"].stringValue
                        
                        let estadoIni = data1["estado_iniciada"].intValue
                        
                        if(estadoIni == 1){
                            self.circuloIniciada.image = UIImage(named: "marcador_azul")
                            self.circuloIniciada.isHidden = false
                            
                            self.btnCancelar.isHidden = true
                        }else{
                            self.btnCancelar.isHidden = false
                        }
                                         
                        
                        // MOTORISTA VIENE EN CAMINO
                        
                        
                        let estadoCamino = data1["estado_camino"].intValue
             
                        if(estadoCamino == 1){
                            
                            self.txtEncamino.text = data1["textocamino"].stringValue
                            self.txtFechaCamino.text = data1["fechacamino"].stringValue
                            
                            
                            self.circuloEncamino.image = UIImage(named: "marcador_azul")
                            self.circuloEncamino.isHidden = false
                            self.btnMotorista.isHidden = false
                         
                        }
                        
                        
                        // ORDEN ENTREGADA
                        
                        
                        let estadoEntrega = data1["estado_entregada"].intValue
                        
                        
                        if(estadoEntrega == 1){
                            
                            self.txtEntregada.text = data1["textoentregada"].stringValue
                            self.txtFechaEntregada.text = data1["fechaentregada"].stringValue
                         
                            self.btnCompletar.isHidden = false
                            self.circuloEntregada.image = UIImage(named: "marcador_azul")
                        }
                        
                        
                        let estadoCancelado = data1["estado_cancelada"].intValue
                        
                        
                        if(estadoCancelado == 1){
                            
                            self.txtIniciada.text = ""
                            self.txtFechaIniciada.text = ""
                            
                            self.boolOrdenCancelada = true
                            
                            self.txtCancelado.text = "ORDEN CANCELADA"
                            
                            self.btnCancelar.setTitle("Borrar", for: .normal)
                            
                            self.circuloCancelada.isHidden = false
                            
                            
                            // MOSTRAR ALERTA CON EL TEXTO DE PORQUE CANCELADA
                        }
                        
                        
                    })
                    
                    
                    self.scrollView.isHidden = false
                    
                    
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryPeticionBuscarOrden()
            }
        }
    }
    
    
    
    func retryPeticionBuscarOrden(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarOrden()
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    
    
    
    @IBAction func btnAccionProducto(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func btnAccionCancelar(_ sender: Any) {
        
        
        
    }
    
    
    
    @IBAction func btnAccionMotorista(_ sender: Any) {
        
        
        
    }
    
    
    
    @IBAction func btnAccionCompletar(_ sender: Any) {
        
        
        
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegateEstadoOrden: protocoloEstadoOrden!
    
    override func viewWillDisappear(_ animated: Bool) {
        delegateEstadoOrden.pasarEstadoOrden(data: recargarVistaOrden)
    }
    
}
