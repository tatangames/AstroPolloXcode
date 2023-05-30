//
//  HorariosController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class HorariosController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var styleAzul = ToastStyle()
    
    var arr = [ModeloHorario]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        // ocultar lineas vacias
        tableView.tableFooterView = UIView()
        peticionBuscarHorarios()
    }
    
    
    func peticionBuscarHorarios(){
        
        //let idClienteusuario = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        let idCliente = "3"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente
        ]
        
        let encodeURL = apiHorarioRestaurante
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      // HORARIOS ENCONTRADOS
                      
                      // nombre de restaurante
                      //self.nombreRestaurante = json["restaurante"].stringValue
                                                        
                    json["horario"].array?.forEach({ (dataArray) in
                                                     
                        let dia = dataArray["dia"].intValue
                        let fechaFormat = dataArray["fechaformat"].stringValue
                                                 
                        self.arr.append(ModeloHorario(dia: dia, fecha: fechaFormat))
                    })
                      
                      
                      self.tableView.reloadData()
                  }
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionBuscarHorarios()
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
    
    
    func retryPeticionBuscarHorarios(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarHorarios()
    }
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arr.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cellReuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HorariosViewCell
           
        let datos = arr[indexPath.row]
        
        switch datos.getDia() {
        case 1:
            // DOMINGO
            cell.txtDia.text = "Domingo"
            cell.txtFecha.text = datos.getFecha()
        case 2:
            // LUNES
            cell.txtDia.text = "Lunes"
            cell.txtFecha.text = datos.getFecha()

        case 3:
            // MARTES
            cell.txtDia.text = "Martes"
            cell.txtFecha.text = datos.getFecha()
            
        case 4:
            // MIERCOLES
            cell.txtDia.text = "Miercoles"
            cell.txtFecha.text = datos.getFecha()
        case 5:
           // JUEVES
            cell.txtDia.text = "Jueves"
            cell.txtFecha.text = datos.getFecha()
        case 6:
           // VIERNES
            cell.txtDia.text = "Viernes"
            cell.txtFecha.text = datos.getFecha()
        case 7:
           // SABADO
            cell.txtDia.text = "Sabado"
            cell.txtFecha.text = datos.getFecha()
       
            
        default:
            cell.txtDia.text = ""
            cell.txtFecha.text = ""
        }
                    
       cell.selectionStyle = .none
                          
        return cell
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}

    
    
