//
//  CategoriasTodasController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage

class CategoriasTodasController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var styleAzul = ToastStilo()
    
    var arr = [ModeloCategorias]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        peticionBuscarCategorias()
    }
    
    
    func peticionBuscarCategorias(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente
        ]
        
        let encodeURL = apiCategoriasTodas
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                    
                    // LISTADO DE CATEGORIAS
                                                                          
                  json["categorias"].array?.forEach({ (dataArray) in
                                                   
                      let idcate = dataArray["id"].intValue
                      let imagen = dataArray["imagen"].stringValue
                      let nombre = dataArray["nombre"].stringValue
                                         
                      self.arr.append(ModeloCategorias(id: idcate, nombre: nombre, imagen: imagen))
                  })
                      
                      self.collectionView.reloadData()
                }
                
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryBuscarCategorias()
              }
        }
        
        
    }
    
    func retryBuscarCategorias(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarCategorias()
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriasTodasCollectionViewCell
        
        let info = arr[indexPath.row]
        
        
        let union = baseUrlImagen + info.getImagen()
                   
        cell.imgCategoria.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
        
     
        cell.txtCategoria.text = info.getNombre()
        
        
        return cell
        
    }
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
                    
        let datos = arr[indexPath.row]

        let idcategoria = datos.getId()
        
       
        let vista : ProductosController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductosController") as! ProductosController
          
         vista.idcategoria = String(idcategoria)
       
       self.present(vista, animated: true, completion: nil)
    }
    
    
    
}
