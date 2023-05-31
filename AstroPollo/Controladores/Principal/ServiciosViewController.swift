//
//  ServiciosViewController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class ServiciosViewController: UIViewController, UICollectionViewDelegate,
                               UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var clvCollectionView: UICollectionView!
   // var arr = [Servicios]()
    
    var styleAzul = ToastStilo()
    let bounds = UIScreen.main.bounds
    
    var mensaje = ""
    
    var cambiarVista = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    
    @IBAction func btnPerfil(_ sender: Any) {
        
        let vistaSiguiente : PerfilController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerfilController") as! PerfilController
            
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return arr.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiciosCollectionCellController", for: indexPath) as! ServiciosCollectionCellController
        
       /* let datos = arr[indexPath.row]
        let nombre = datos.nombre
        let imagen = datos.imagen
        
        cell.txtServicio.text = nombre
                 
        cell.vistaCell.layer.cornerRadius = 20.0
        cell.vistaCell.layer.shadowColor = UIColor.gray.cgColor
        cell.vistaCell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.vistaCell.layer.shadowRadius = 2.0
        cell.vistaCell.layer.shadowOpacity = 0.7
        
        let urlServicios = urlServicio
        let union = urlServicios+imagen
        
        cell.imgServicio.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "foto_default"))*/
        
        return cell;
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                        
       /* let datos = arr[indexPath.row]
        let tipoServicio = datos.tipos_id
        let idservicio = datos.tipoServicioID
        let mensaje = datos.descripcion
        
        vistaLocales(idservicio: idservicio, tipoServicio: tipoServicio, mensaje: mensaje)*/
    }
    
    
}
