//
//  CarritoComprasController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 3/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire


protocol protocoloCarrito {
  func pasarDatoCarrito(actualizar: Bool)
}

protocol protocoloProcesarOrden {
  func actualizarVista(actualizar: Bool)
}

class CarritoComprasController: UIViewController, protocoloCarrito, UITableViewDataSource, UITableViewDelegate, protocoloProcesarOrden {
   
    
    func actualizarVista(actualizar: Bool) {
        if(actualizar){
            var estilo = ToastStilo()
            
            estilo.backgroundColor = UIColor(named: "ColorAzulToast")!
            estilo.messageColor = .white
            
            self.view.makeToast("Actualizado", duration: 2, position: .bottom, style: estilo)
            
            peticionBuscarCarrito()
        }
    }
    
    
    
    func pasarDatoCarrito(actualizar: Bool) {
            
        if(actualizar){
                        
            var estilo = ToastStilo()
            
            estilo.backgroundColor = UIColor(named: "ColorVerde")!
            estilo.messageColor = .white
            
            self.view.makeToast("Actualizado", duration: 2, position: .bottom, style: estilo)
            
            peticionBuscarCarrito()
        }
     }
    
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnProcesar: UIButton!
    
    
    
    // para saber si hay productos en el carrito
    var carritoBool = false
    
    // 0: uno o varios productos no estan disponibles
    // 1: productos disponibles todos
    var estadoProductoGlobal = 1
    
    
    var styleAzul = ToastStilo()    
    var arrCarrito = [ModeloCarrito]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        peticionBuscarCarrito()
    }
    
    // ESTO ES CUANDO SE TOCA BOTON DEL TAB
    var booleanTouchBoton = false
    
    func recargarTouchBoton(){
        
        if(booleanTouchBoton){
            peticionBuscarCarrito()
        }
    }
                
            
    func peticionBuscarCarrito(){
        
        arrCarrito.removeAll()
        tableView.reloadData()
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiBuscarCarritoCompras
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                    // SI HAY PRODUCTOS EN EL CARRITO
                    
                    
                    let estadoProGlo = json["estadoProductoGlobal"].intValue
                    let subTotalGlo = json["subtotal"].stringValue
                    
                    
                    json["producto"].array?.forEach({ (dataArray) in
                        
                        let idProId = dataArray["productoID"].intValue
                        let nombre = dataArray["nombre"].stringValue
                        let cantidad = dataArray["cantidad"].intValue
                        let imagen = dataArray["imagen"].stringValue
                        let precio = dataArray["precioformat"].stringValue
                        let activo = dataArray["activo"].intValue
                        let carritoid = dataArray["carritoid"].intValue // fila del carrito para editar/borrar
                        let utilizaimagen = dataArray["utiliza_imagen"].intValue
                        let estadolocal = dataArray["estadoLocal"].intValue
                        let titulo = dataArray["titulo"].stringValue
                        let mensaje = dataArray["mensaje"].stringValue
                        
                        self.arrCarrito.append(ModeloCarrito(productoID: idProId, nombre: nombre, cantidad: cantidad, imagen: imagen, precio: precio, activo: activo, carritoid: carritoid, utiliza_imagen: utilizaimagen, estadoLocal: estadolocal, titulo: titulo, mensaje: mensaje))
                    })
                                        
                    self.btnProcesar.isHidden = false
                    self.btnProcesar.setTitle("Sub Total $" + subTotalGlo, for: .normal)
                    self.estadoProductoGlobal = estadoProGlo
                             
                    self.carritoBool = true
                    self.booleanTouchBoton = true
                    
                    self.tableView.reloadData()
                }
                else if(codigo == 2){
                    
                    // CARRITO DE COMPRAS VACIO
                    
                    self.mensajeToastAzul(mensaje: "Carrito vacío")
                    
                    self.btnProcesar.isHidden = true
                    self.carritoBool = false
                    self.booleanTouchBoton = true
                }
                
                else{
                    self.booleanTouchBoton = true
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryBuscarCarrito()
            }
        }
    }
        
    
    
    func retryBuscarCarrito(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarCarrito()
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
                
    
    
    
    
    @IBAction func btnAccionProcesar(_ sender: Any) {
        
        if(!carritoBool){
            mensajeToastAzul(mensaje: "Carrito de compras no encontrado")
            return
        }
        
        if(estadoProductoGlobal == 0){
            
            alertaProductoNoActivo(titulo: "Producto no Disponible", mensaje: "El Producto Marcado no se encuentra disponible, puede eliminar deslizando hacia la izquierda. Gracias")
            return
        }
        
        
        let vistaSiguiente : ProcesarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProcesarController") as! ProcesarController
                
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
   
    
    
    func recargarApp(){
        let vista : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnBorrar(_ sender: Any) {
        
        if(carritoBool){
          alertaBorrarCarrito()
        }
    }
    
    func alertaBorrarCarrito(){
        
        
        let alert = UIAlertController(title: "Borrar Carrito", message: nil, preferredStyle: UIAlertController.Style.alert)
                     
         alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
             alert.dismiss(animated: true, completion: nil)
         }))
         
         alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
             alert.dismiss(animated: true, completion: nil)
             
           self.peticionBorrarCarrito()
         }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionBorrarCarrito(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiBorrarCarrito
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                    // CARRITO DE COMPRAS BORRADO
                    self.alertaCarritoBorrado()
                }
                else if(codigo == 2){
                    
                    // CARRITO NO ENCONTADO PERO IGUAL DECIR QUE FUE BORRADO
                    self.alertaCarritoBorrado()
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
        
    
    func alertaCarritoBorrado(){
        
        arrCarrito.removeAll()
        tableView.reloadData()
        btnProcesar.isHidden = true
        carritoBool = false
        
        let alert = UIAlertController(title: "Carrito Borrado", message: nil, preferredStyle: UIAlertController.Style.alert)
         
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
             alert.dismiss(animated: true, completion: nil)
             
           self.recargarApp()
            
         }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrCarrito.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CarritoCollectionViewCell
           
        let datos = arrCarrito[indexPath.row]
        
        cell.txtCantidad.text = " \(datos.getCantidad())x "
        cell.txtNombre.text = datos.getNombre()
        
            
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
                        
        cell.txtPrecio.text = datos.getPrecio()
        
        
        // SI PRODUCTO TIENE PROBLEMAS
        
        if(datos.getEstadoLocal() == 1){
            //
            cell.backgroundColor = UIColor(named: "ColorRojoCarrito")!
            cell.txtNombre.textColor = UIColor.white
            cell.txtPrecio.textColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.white
            cell.txtNombre.textColor = UIColor(named: "ColorGrisV1")!
            cell.txtPrecio.textColor = UIColor(named: "ColorAzulToast")!
        }
                    
       cell.selectionStyle = .none
                          
       return cell
    }
        
     // obtener el producto seleccionado
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let datos = arrCarrito[indexPath.row]
         
         // REGLAS
         
         // 1- PRODUCTO NO ACTIVO
         // 2- SUB CATEGORIA NO ACTIVA
         // 3- CATEGORIA NO ACTIVA
         // 4- CATEGORIA HORARIO NO ACTIVA
         
         
         // PRODUCTOS NO DISPONILES
         
         let tituloPro = datos.getTitulo()
         let mensajePro = datos.getMensaje()
         
         if(datos.getEstadoLocal() == 1){
             alertaProductoNoActivo(titulo: tituloPro, mensaje: mensajePro)
             return
         }
         
         // PUEDE EDITAR PRODUCTO
                  
           let vista : EditarProductoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditarProductoController") as! EditarProductoController
             
           vista.delegate = self
           vista.idcarritofila = String(datos.getCarritoID())
          
          self.present(vista, animated: true, completion: nil)
     }
    
    var produtoIDBorrar = 0
     
     // borrar un producto
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if(editingStyle == UITableViewCell.EditingStyle.delete){
                        
            let datos = arrCarrito[indexPath.row]
            self.produtoIDBorrar = datos.getCarritoID()
            
            arrCarrito.remove(at: indexPath.row)
            tableView.reloadData()
                        
            peticionBorrarProducto()
        }
     }
       
    // estilo para el boton borrar
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let deleteButton = UITableViewRowAction(style: .default, title: "Borrar") { (action, indexPath) in
           self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
           return
       }
        
       deleteButton.backgroundColor = UIColor.red

       return [deleteButton]
    }
    
    
    
    func alertaProductoNoActivo(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
         
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
             alert.dismiss(animated: true, completion: nil)
                         
         }))
        
        self.present(alert, animated: true, completion: nil)
    }
        
    
    
    
    func peticionBorrarProducto(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente,
            "carritoid": String(produtoIDBorrar)
        ]
        
        let encodeURL = apiBorrarProductoCarrito
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                    // CARRITO DE COMPRAS BORRADO COMPLETAMENTE
                    self.alertaCarritoBorrado()
                    
                }
                else if(codigo == 2){
                    
                    // PRODUCTO ELIMINADO
                    self.mensajeToastAzul(mensaje: "Producto Borrado")
                    self.peticionBuscarCarrito()
                }
                else if(codigo == 3){
                    
                    // PRODUCTO NO ENCONTRADO PERO DECIR QUE FUE ELIMINADO
                    self.mensajeToastAzul(mensaje: "Producto Borrado")
                    self.peticionBuscarCarrito()
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
    
    
    
    
    
}
