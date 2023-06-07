//
//  ProductosOrdenController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 6/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire



class ProductosOrdenController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    
    var styleAzul = ToastStilo()
    var arrProductos = [ModeloProductoOrden]()
    
    var idorden = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        peticionBuscar()
    }

    
    func peticionBuscar(){
        
                        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "ordenid": String(idorden)
        ]
        
        let encodeURL = apiListadoProductosOrden
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                                  
                    
                    json["productos"].array?.forEach({ (dataArray) in
                        
                        let idOrdenDesc = dataArray["idordendescrip"].intValue
                        let cantidad = dataArray["cantidad"].intValue
                        let nota = dataArray["nota"].stringValue
                        let nombrePro = dataArray["nombreproducto"].stringValue
                        
                        let imagen = dataArray["imagen"].stringValue
                        let precio = dataArray["precio"].stringValue
                        let utilizaimagen = dataArray["utiliza_imagen"].intValue
                       
                        
                        self.arrProductos.append(ModeloProductoOrden(idOrdenDescrip: idOrdenDesc, cantidad: cantidad, nota: nota, imagen: imagen, utilizaImagen: utilizaimagen, precio: precio, nombreProducto: nombrePro))
                    })
                    
                    self.tableView.isHidden = false
                           
                    self.tableView.reloadData()
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
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrProductos.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProcuctosOrdenTableViewCell
           
        let datos = arrProductos[indexPath.row]
        
        cell.txtCantidad.text = " \(datos.getCantidad())x "
        cell.txtNombre.text = datos.getNombreProducto()
                           
        if(datos.getUtilizaImagen() == 1){
                            
            let union = baseUrlImagen+datos.getImagen()

            if (!datos.getImagen().isEmpty){
                
                cell.imgProducto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                cell.imgProducto.layer.masksToBounds = false
                cell.imgProducto.layer.cornerRadius = (cell.imgProducto.frame.height)/2
                cell.imgProducto.clipsToBounds = true
            }
        }else{
            cell.imgProducto.image = UIImage(named:"fotodefault")
        }
        
        
        cell.txtPrecio.text = "$" + datos.getPrecio()
        
        
                    
       cell.selectionStyle = .none
                          
       return cell
    }
        
   
    
    
    
    
    
    
    
    
}

