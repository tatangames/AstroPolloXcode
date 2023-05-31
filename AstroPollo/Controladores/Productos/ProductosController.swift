//
//  ProductosController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage
import Toast_Swift


class Platos {
        
    // estructura de productos
    struct PlatosArray {
        var idProducto: Int
        var nombreProducto: String
        var descripcionProducto: String
        var imagenProducto: String
        var precioProducto: String
        var utilizaImagen: Int
    }
    
    // informacion para el local
    var nombreSeccion: String?
    
    
    var tipoPlato: [PlatosArray]?
        
    init(nombreSeccion: String, tipoPlato: [PlatosArray]) {
        self.nombreSeccion = nombreSeccion
        self.tipoPlato = tipoPlato
    }
}



protocol protocoloProductoGuardado {
    func mostrarToast(seActualizo: Bool)
}



class ProductosController: UIViewController,  UITableViewDataSource, UITableViewDelegate, protocoloProductoGuardado  {
        
    func mostrarToast(seActualizo: Bool) {
    
       if(seActualizo){
           //self.mensajeToast(mensaje: "Producto Agregado")
           
          
           var estilo = ToastStyle()
           
           estilo.backgroundColor = .green
           estilo.messageColor = .white
           
           self.view.makeToast("Producto Guardado", duration: 2, position: .bottom, style: estilo)

       }
    }
    
    
    
 
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var styleAzul = ToastStilo()
    
    var platoArray = [Platos]()
    var arr = [Platos.PlatosArray]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleAzul.backgroundColor = UIColor(red: 45, green: 88, blue: 156, alpha: 1)
        styleAzul.titleColor = .white
   
        tableView.tableFooterView = UIView()
        
        tableView.sectionHeaderHeight =  UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25;
                        
        peticionBuscarProductor()
    }
    
  
    
    
    func peticionBuscarProductor(){
                 
           MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let idcategoria = "1"
           
           let params = [
               "id": idcategoria
           ]
           
           let encodeURL = apiProductosListadoMenu
        
           
            AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                          
                          switch response.result{
                            case .success(let value):
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                let json = JSON(value)
                             
                                let codigo = json["success"]
                                
                                if(codigo == 1){
                                            
                                  json["productos"].array?.forEach({ (dataArray) in
                                                                  
                                    
                                    let nombreseccion = dataArray["nombre"].stringValue
                                                                                                        
                                      dataArray["productos"].array?.forEach({ (data4) in
                                                                                      
                                            let id = data4["id"].intValue
                                            let nombre = data4["nombre"].stringValue
                                            let descripcion = data4["descripcion"].stringValue
                                            let imagen = data4["imagen"].stringValue
                                            let precio = data4["precio"].stringValue
                                            let utilizaimagen = data4["utiliza_imagen"].intValue
                                            
                                            // AGREGANDO CADA PRODUCTO
                                            
                                            self.arr.append(Platos.PlatosArray(idProducto: id, nombreProducto: nombre, descripcionProducto: descripcion, imagenProducto: imagen, precioProducto: precio, utilizaImagen: utilizaimagen))
                                        })
                                             
                                    // LLENANDO LA SECCION CON SU PRODUCTO
                                      self.platoArray.append(Platos.init(nombreSeccion: nombreseccion, tipoPlato: self.arr))
                                                    
                                      
                                    self.arr.removeAll()
                                  })
                                    
                                                                        
                                    self.tableView.reloadData()
                                                                       
                                  
                                } else{
                                      MBProgressHUD.hide(for: self.view, animated: true)
                                      self.mensajeToast(mensaje: "Sin conexion")
                                  }
                      
                            case .failure( _):
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.reintento()
                            }
                      }
       }
    
    
    
    // tipo de mensaje toast
     func mensajeToast(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
     }
    
     // reintento de peticion
     func reintento(){
        peticionBuscarProductor()
     }
         
     // retorno de numero de secciones
     func numberOfSections(in tableView: UITableView) -> Int {
         return platoArray.count
     }
       
     // numero de cada seccion
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           if section == 0 {
               return 1
           }
          // return mobileBrand[section].modelName?.count ?? 0
           let contador = platoArray[section].tipoPlato?.count ?? 0
                 
           return contador
       }
           
     // llenado de cada fila
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
             
           let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ListaProductosTableViewCell
              
           cell.txtNombre.text = platoArray[indexPath.section].tipoPlato?[indexPath.row].nombreProducto
           cell.txtPrecio.text = "$"+(platoArray[indexPath.section].tipoPlato?[indexPath.row].precioProducto ?? "")
           
           let conteo = (platoArray[indexPath.section].tipoPlato?[indexPath.row].descripcionProducto.count)!
           
         if conteo == 0 {
             
             cell.txtDescripcion.isHidden = true
             
         }else{
             
             if conteo > 80 {
                 let texto = platoArray[indexPath.section].tipoPlato?[indexPath.row].descripcionProducto
                 let cortado = String(texto?.prefix(80) ?? "")
                 cell.txtDescripcion.text = cortado+"..."
               
             }else {
                 cell.txtDescripcion.text = platoArray[indexPath.section].tipoPlato?[indexPath.row].descripcionProducto
             }
             
             cell.txtDescripcion.isHidden = false
         }
                  
         
           let utilizaImagen = (platoArray[indexPath.section].tipoPlato?[indexPath.row].utilizaImagen)!
           
           if utilizaImagen == 1{
               
               let imageURL = platoArray[indexPath.section].tipoPlato?[indexPath.row].imagenProducto ?? ""
                 
               let union = baseUrlImagen+imageURL
               
               if !imageURL.isEmpty {
                   cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                   
                   cell.imgFoto.layer.masksToBounds = false
                   cell.imgFoto.layer.cornerRadius = (cell.imgFoto.frame.height)/2
                   cell.imgFoto.clipsToBounds = true
                 
                  cell.imgFoto.isHidden = false
               }
               
           }else{
               // ocultar imagen y actualizar constraint
               //cell.imgLogo.image = UIImage(named:"foto_default.jpg")
               cell.imgFoto.isHidden = true
           }
           
           return cell
       
   }
       
     // estilo para el nombre de cada seccion
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

         let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! TitularProductoTableViewCell
         
         cell.txtTitulo.text = platoArray[section].nombreSeccion
     
         return cell.contentView
     }
     
     // oculta la primera cabecera
     /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           //return 40
           let headerHeight: CGFloat

             switch section {
             case 0:
                 // hide the header
                 headerHeight = CGFloat.leastNonzeroMagnitude
                 return headerHeight
             default:
                return UITableView.automaticDimension
             }
      }*/

   // elegir producto
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
     let idproducto = platoArray[indexPath.section].tipoPlato?[indexPath.row].idProducto ?? 0
     
       let vista : ElegirCantidadController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ElegirCantidadController") as! ElegirCantidadController
         
        vista.delegate = self
        vista.idproducto = String(idproducto)
      
      self.present(vista, animated: true, completion: nil)
   }
    
    
    
}
