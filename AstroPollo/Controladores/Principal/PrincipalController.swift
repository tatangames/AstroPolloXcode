//
//  PrincipalController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 31/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class PrincipalController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    
    var styleAzul = ToastStilo()
    var arrBanner = [ModeloBanner]()
    var arrCategorias = [ModeloCategoriasPrincipal]()
        
    
    @IBOutlet weak var bannerCollecionView: UICollectionView!
    @IBOutlet weak var categoriaCollectionView: UICollectionView!
    @IBOutlet weak var paginaControl: UIPageControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        registrarCeldas()
        peticionMenu()
    }
        
    
    func registrarCeldas() {
        categoriaCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    @IBAction func btnAccionPerfil(_ sender: Any) {
     
     
    }
    
    

    
    func peticionMenu(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
                  
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente
        ]
        
        let encodeURL = apiObtenerMenuPrincipal
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
               
                  if(codigo == 3){
                    
                   // let hayCategorias = json["haycategorias"].stringValue
                   // let hayPopulares = json["haypopulares"].stringValue
                   
                    
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
                                                                  
                      self.bannerCollecionView.reloadData()
                      self.categoriaCollectionView.reloadData()
                      
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
            
        default: return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
       switch collectionView {
        case categoriaCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: arrCategorias[indexPath.row])
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
    
    
    
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }*/
   
    
 
    
}
