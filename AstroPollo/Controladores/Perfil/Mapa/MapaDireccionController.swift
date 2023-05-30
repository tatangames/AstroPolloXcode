//
//  MapaDireccionController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import UIKit
import Alamofire
import MBProgressHUD
import GoogleMaps
import CoreLocation
import SwiftyJSON

 class MapaDireccionController: UIViewController{
     
     // MAPA

    @IBOutlet weak var google_map: GMSMapView!
    let locationManager = CLLocationManager()
    var polygon = GMSPolygon()
    var polygonList = [GMSPolygon]()
    @IBOutlet weak var btnMapa: UIButton!
    var styleAzul = ToastStyle()
    
    var latitudreal = ""
    var longitudreal = ""
    
    
    var segurocarga = false
    
    
    var indicator: BarraProgresoController?
     
    @IBOutlet weak var boton: UIButton!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
           self.boton.layer.cornerRadius = 10
           self.boton.clipsToBounds = true
        
        indicator = BarraProgresoController(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Cargando..")
           self.view.addSubview(indicator!)
        
            //btnMapa.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
                
            google_map.settings.compassButton = true
            google_map.isMyLocationEnabled = true
            google_map.settings.myLocationButton = true
        
            centerViewOnUserLocation()
        
         indicator!.start()
        
        peticionServidor()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
        let nav = self.navigationController?.navigationBar
        //nav?.tintColor = UIColor(45,88,156,1)
        nav?.tintColor = UIColor(red: 45, green: 88, blue: 156, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 45, green: 88, blue: 156, alpha: 1)]
    }
    
    func centerViewOnUserLocation(){
     if let location = locationManager.location?.coordinate {
           
         let location = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
          google_map.animate(to: location)
        }
    }
    
    
    // solicitar poligonos
       func peticionServidor(){
               
               //let usuarioid = UserDefaults.standard.getValueIdUsuario() ?? ""
                     
               //MBProgressHUD.showAdded(to: self.view, animated: true)
         
               let encodeURL = apiListaDePoligonos
               
               AF.request(encodeURL, method: .get, parameters: nil).responseJSON{ (response) in
                   
                   switch response.result{
                     case .success(let value):
                         
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        self.indicator!.stop()
                         
                         let json = JSON(value)
                      
                         let codigo = json["success"]
                         
                         if(codigo == 1){

                            self.segurocarga = true
                            
                           json["poligono"].array?.forEach({ (user) in
                             
                               let idZona = user["id"].intValue
                              
                                 let path = GMSMutablePath()
                             
                                 user["poligonos"].array?.forEach({ (user2) in
                                     //print(user2["latitudPoligono"].stringValue)
                                   let lati = user2["latitudPoligono"].stringValue
                                   let longi = user2["longitudPoligono"].stringValue
                                       
                                   path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees((lati as NSString).floatValue), longitude: CLLocationDegrees((longi as NSString).floatValue)))
                                   
                                 })
                                   
                               self.polygon = GMSPolygon(path: path)
                               self.polygon.strokeColor = UIColor(red: 25, green: 118, blue: 210, alpha: 1)
                               self.polygon.fillColor = UIColor(red: 0, green: 255, blue: 1, alpha: 0.1)
                               self.polygon.strokeWidth = 1.0
                               self.polygon.title = String(idZona)
                               self.polygon.map = self.google_map
                               
                               self.polygonList.append(self.polygon)
                           
                           })
                           
                         } else{
                               //MBProgressHUD.hide(for: self.view, animated: true)
                            self.indicator!.stop()
                            self.mensajeToast(mensaje: "Sin conexion")
                           }
               
                     case .failure( _):
                            //self.indicator!.stop()
                         //MBProgressHUD.hide(for: self.view, animated: true)
                         self.reintento()
                     }
               }
       }
       
       func mensajeToast(mensaje: String){
           self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
       }
       
       func reintento(){
            MBProgressHUD.hide(for: self.view, animated: true)
           peticionServidor()
       }
       
    @IBAction func btnSeleccionar(_ sender: Any) {
        
        if(!segurocarga){
            mensajeToast(mensaje: "Cargando Cobertura")
        }else{
            let pos = google_map.camera.target
             var valor = true
             
             for pol in polygonList{
                 if (GMSGeometryContainsLocation(pos, pol.path!, true)) {
                      let idzona = pol.title ?? ""
                      let latitud = pos.latitude
                      let longitud = pos.longitude
                      vistaFormulario(id: idzona, latitud: String(latitud), longitud: String(longitud))
                      valor = false
                      break;
                  }
             }
                 
             // mostrar mensaje que no damos servicio aqui
             if(valor){
                 fueraUbicacion()
             }
        }
     
   }
   
    func fueraUbicacion(){
           let alert = UIAlertController(title: "Sin Servicio", message: "Lo sentimos, no ofrecemos nuestro servicio en esta ubicación", preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
           }))
           
           self.present(alert, animated: true, completion: nil)
    }
       
    func vistaFormulario(id: String, latitud: String, longitud: String){
        
        if let location = locationManager.location?.coordinate {
           
            latitudreal = String(location.latitude)
            longitudreal = String(location.longitude)
        }
        
        
        /*let vista : InfoDireccionViewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InfoDireccionViewController") as! InfoDireccionViewController
               vista.idzona = id
               vista.latitud = latitud
               vista.longitud = longitud
               vista.latitudreal = latitudreal
               vista.longitudreal = longitudreal
               
           self.present(vista, animated: true, completion: nil)*/
    }
     
     
     @IBAction func btnAtras(_ sender: Any) {
         dismiss(animated: true, completion: nil)
     }
     
     
 }


 extension MapaDireccionController: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //  guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
     }
 }
