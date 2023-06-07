//
//  InformacionMotoristaController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 6/6/23.
//

import Foundation
import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire



class InformacionMotoristaController: UIViewController {
    
    var idorden = 0
    var styleAzul = ToastStilo()
    
    
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtTransporte: UILabel!
    @IBOutlet weak var txtPlaca: UILabel!
    @IBOutlet weak var vista: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
       
        
        peticionBuscarMotorista()
    }
    
    func peticionBuscarMotorista(){
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "ordenid": idorden
        ]
        
        let encodeURL = apiVerMotorista
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
           
                if(codigo == 1){
                    
                    
                    let foto = json["foto"].stringValue
                    let nombre = json["nombre"].stringValue
                    let vehiculo = json["vehiculo"].stringValue
                    let placa = json["placa"].stringValue
                    
                    
                    let union = baseUrlImagen + foto
                    
                    self.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                    
                    self.txtNombre.text = "Nombre: " + nombre
                    self.txtTransporte.text = "Vehículo: " + vehiculo
                    self.txtPlaca.text = "Placa: " + placa
                    
                    
                    self.vista.isHidden = false
                }
               
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryBuscar()
            }
        }
        
    }
    
    
    func retryBuscar(){
        
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarMotorista()
    }
    
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
}
