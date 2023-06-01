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
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var coleccionCategorias: UICollectionView!
    
    
    
    
    @IBOutlet weak var coleccionBanner: UICollectionView!
    
    var currentCellIndex = 0
    var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        pageControl.currentPage = 0
        
        registrarCeldas()
        
     
        peticionMenu()
    }
    
     func registrarCeldas() {
        coleccionCategorias.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
       
    }
    
    
    @objc func slideToNext(){
        
        if currentCellIndex < arrBanner.count - 1
        {
            currentCellIndex = currentCellIndex + 1
        }else{
            currentCellIndex = 0
        }
        
        
        coleccionBanner.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .right, animated: true)
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
                    
                    let hayCategorias = json["haycategorias"].stringValue
                    let hayPopulares = json["haypopulares"].stringValue
                   
                    
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
                        
                      
                      
                      
                    
                      self.pageControl.numberOfPages = self.arrBanner.count
                      self.coleccionBanner.reloadData()
                     
                      self.coleccionCategorias.reloadData()
                      
                      
                      self.startTimer()
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
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:
            #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextIndex(){
        
        if(currentCellIndex < arrBanner.count - 1){
            currentCellIndex = currentCellIndex + 1
        }else{
            currentCellIndex = 0
        }
        
        pageControl.currentPage = currentCellIndex
        
        coleccionBanner.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0),
                                          at: .right, animated: true)
       
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
        return arrBanner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PrincipalCollectionViewCell
        
        let info = arrBanner[indexPath.row]
        let union = baseUrlImagen + info.getImagen()
                   
        cell.imagenBanner.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
        
        cell.imagenBanner.layer.cornerRadius = 50
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    

    
}
