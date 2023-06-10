//
//  PrincipalAccesoLibreController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 9/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class PrincipalAccesoLibreController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
 
  
    var styleAzul = ToastStilo()
    var arrBanner = [ModeloBanner]()
    var arrCategorias = [ModeloCategoriasPrincipal]()
    var arrProductos = [ModeloProductoPopular]()
            
    @IBOutlet weak var bannerCollecionView: UICollectionView!
    @IBOutlet weak var categoriaCollectionView: UICollectionView!
    @IBOutlet weak var paginaControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productoCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        registrarCeldas()
        peticionMenu()
    }
        
    
    func registrarCeldas() {
        categoriaCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        productoCollectionView.register(UINib(nibName: ProductoPoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductoPoCollectionViewCell.identifier)
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        
        let vistaSiguiente : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    
    

    
    func peticionMenu(){
        
                         
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // POR DEFECTO SERA ID 3, PARA MOSTRAR EJEMPLOS
        
        let params = [
            "id": "3"
        ]
        
        let encodeURL = apiObtenerMenuPrincipal
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                
                
                // NUNCA FALTARA DIRECCION
                // NUNCA USUARIO ESTARA BLOQUEADO
               
                 if(codigo == 3){
                    
                                  
                    // LISTADO DE BANNER
                                                                          
                  json["slider"].array?.forEach({ (dataArray) in
                                                   
                      let idProducto = dataArray["id_producto"].intValue
                      let imagen = dataArray["imagen"].stringValue
                      let redireccionamiento = dataArray["redireccionamiento"].intValue
                                           
                                                                                        
                      self.arrBanner.append(ModeloBanner(idProducto: idProducto, imagen: imagen, redireccionamiento: redireccionamiento))
                  })
                      
                      // LISTADO DE CATEGORIAS
                      
                      json["categorias"].array?.forEach({ (dataArray) in
                                                       
                          let idC = dataArray["id"].intValue
                          let imagenC = dataArray["imagen"].stringValue
                          let nombreC = dataArray["nombre"].stringValue
                                               
                                                                      
                          self.arrCategorias.append(ModeloCategoriasPrincipal(id: idC, nombre: nombreC, imagen: imagenC))
                      })
                      
                      
                      // LISTADO DE PRODUCTOS POPULARES
                      
                      json["populares"].array?.forEach({ (dataArray) in
                                                       
                          let idP = dataArray["id"].intValue
                          let imagenP = dataArray["imagen"].stringValue
                          let nombreP = dataArray["nombre"].stringValue
                          let precioP = dataArray["precio"].stringValue
                          let usaImagen = dataArray["utiliza_imagen"].intValue
                                                                      
                          self.arrProductos.append(ModeloProductoPopular(id: idP, imagen: imagenP, nombre: nombreP, utiliza_imagen: usaImagen, precio: precioP))
                      })
                                                                                        
                      self.bannerCollecionView.reloadData()
                      self.categoriaCollectionView.reloadData()
                      self.productoCollectionView.reloadData()
                     
                      self.scrollView.isHidden = false
                                        
                      // para timer de banner
                      self.ajustar()
                    
                  }
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                  }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryBuscarMenu()
              }
        }
    }
    
    
    func ajustar(){
        paginaControl.numberOfPages = arrBanner.count
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(pageSetup), userInfo: nil, repeats: true)
    }
    
    var index = 0
    
    @objc func pageSetup(){
        if index < arrBanner.count - 1 {
            index = index + 1
        }else {
            index = 0
        }
      
        paginaControl.currentPage = index
        bannerCollecionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    
    
    func retryBuscarMenu(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionMenu()
    }
    
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bannerCollecionView:
            return arrBanner.count
        case categoriaCollectionView:
            return arrCategorias.count
        case productoCollectionView:
            return arrProductos.count
            
        default: return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
       switch collectionView {
        case categoriaCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: arrCategorias[indexPath.row])
            return cell
       case productoCollectionView:
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductoPoCollectionViewCell.identifier, for: indexPath) as! ProductoPoCollectionViewCell
           cell.setup(producto: arrProductos[indexPath.row])
           return cell
        case bannerCollecionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellbanner", for: indexPath) as! BannerCollectionViewCell
           
            let info = arrBanner[indexPath.row]
            let union = baseUrlImagen + info.getImagen()
                       
           cell.imgBanner.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                                    
            return cell
    
        default: return UICollectionViewCell()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        switch collectionView {
         case bannerCollecionView:
            let datos = arrBanner[indexPath.row]
 
            let redirec = datos.getRedireccionamiento()
            let idpro = datos.getIdProducto()
            
            redireccionBanner(redirecciona: redirec, idProducto: idpro)
                        
        case categoriaCollectionView:
           
            let datos = arrCategorias[indexPath.row]
 
            let idcategoria = datos.getId()
            
            redireccionCategoria(idcategoria: idcategoria)
            
         case productoCollectionView:
            let datos = arrProductos[indexPath.row]
            let idpro = datos.getId()
            
            redireccionProductoPopular(idproducto: idpro)
     
         default:
            
            // POR DEFECTO ESTA BANNER
            
            
            let datos = arrBanner[indexPath.row]
 
            let redirec = datos.getRedireccionamiento()
            let idpro = datos.getIdProducto()
            
            redireccionBanner(redirecciona: redirec, idProducto: idpro)
         }
    }
    
    
    
    func redireccionBanner(redirecciona: Int, idProducto: Int){
        
        if(redirecciona == 1){
            
            if(idProducto != 0){
                                
                let vista : ProIndividualLibreAccesoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProIndividualLibreAccesoController") as! ProIndividualLibreAccesoController
                
                vista.idproducto = idProducto
                 
               self.present(vista, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func redireccionCategoria(idcategoria: Int){
        
        let vista : ProductosLibreAccesoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductosLibreAccesoController") as! ProductosLibreAccesoController
          
         vista.idcategoria = String(idcategoria)
       
       self.present(vista, animated: true, completion: nil)
    }
    
    
    func redireccionProductoPopular(idproducto: Int){
                
          let vista : ProIndividualLibreAccesoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProIndividualLibreAccesoController") as! ProIndividualLibreAccesoController
        
        vista.idproducto = idproducto
           
         self.present(vista, animated: true, completion: nil)
    }
    
        
 
}
