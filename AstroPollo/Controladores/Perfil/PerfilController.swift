//
//  PerfilController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class PerfilController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct DatosPerfil {
        let posicion: Int
        let titulo: String
        let imagen: String
    }
    
    let data: [DatosPerfil] = [
        DatosPerfil(posicion: 1, titulo: "Direcciones", imagen: "iconomapa"),
        DatosPerfil(posicion: 2, titulo: "Cambio de Contraseña", imagen: "iconocandado"),
        DatosPerfil(posicion: 3, titulo: "Perfil", imagen: "iconomensaje"),
        DatosPerfil(posicion: 4, titulo: "Eliminar Cuenta", imagen: "iconounlock"),
        DatosPerfil(posicion: 5, titulo: "Horarios", imagen: "reloj"),
        DatosPerfil(posicion: 6, titulo: "Historial", imagen: "calendario"),
        DatosPerfil(posicion: 7, titulo: "Premios", imagen: "medalla"),
        DatosPerfil(posicion: 8, titulo: "Soporte", imagen: "soporte"),
        DatosPerfil(posicion: 9, titulo: "Cerrar Sesión", imagen: "iconounlock"),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PerfilViewCell
        cell.textoPerfil.text = info.titulo
        cell.imagenPerfil.image = UIImage(named: info.imagen)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    // obtener el producto seleccionado
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
        let datos = data[indexPath.row].posicion
      
        
        if(datos == 1){
            // DIRECCIONES
            pasarVistaDirecciones()
        }
        
        else if(datos == 2){
            // ACTUALIZAR CONTRASEÑA
            pasarVistaContrasena()
        }
        
        else if(datos == 3){
            // PERFIL
            // actualizar correo
            pasarVistaPerfil()
        }
        
        else if(datos == 4){
            // BORRAR CLIENTE
        
            pasarVistaEliminarCliente()
        }
      
        else if(datos == 5){
            // HORARIOS
            pasarVistaHorario()
        }
        
        else if(datos == 6){
            // HISTORIAL
            pasarVistaHistorial()
        }
        else if(datos == 7){
            // PREMIOS
            pasarVistaPremios()
        }
        
        else if(datos == 8){
            // SOPORTE
            pasarVistaSoporte()
        }
        
        else{
            // CERRAR SESION
            pasarCerrarSesion()
        }
    }
    
    
    @IBAction func btnPerfil(_ sender: Any) {
        
        let vistaSiguiente : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    func pasarVistaHistorial(){
        let vistaSiguiente : HistorialBotonFechaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "HistorialBotonFechaController") as! HistorialBotonFechaController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    func pasarVistaDirecciones(){
        let vistaSiguiente : ListaDireccionesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListaDireccionesController") as! ListaDireccionesController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    func pasarVistaPremios(){
        let vistaSiguiente : ListaPremiosController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListaPremiosController") as! ListaPremiosController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    func pasarVistaPerfil(){
        let vistaSiguiente : PerfilCorreoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerfilCorreoController") as! PerfilCorreoController
        
        self.present(vistaSiguiente, animated: true, completion: nil)        
    }
    
    
    func pasarVistaHorario(){
        let vistaSiguiente : HorariosController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HorariosController") as! HorariosController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
     
    
    func pasarVistaContrasena(){
        let vistaSiguiente : PasswordPerfilController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordPerfilController") as! PasswordPerfilController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    func pasarVistaSoporte(){
        
        let vistaSiguiente : SoporteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SoporteViewController") as! SoporteViewController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
        
    }
    
    
    func pasarVistaEliminarCliente(){
        
        let vistaSiguiente : EliminacionClienteController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EliminacionClienteController") as! EliminacionClienteController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    func pasarCerrarSesion(){
                   
           let alert = UIAlertController(title: "Cerrar Sesión", message: nil, preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
           }))
           
           alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
               
               self.salir()
           }))
           
           self.present(alert, animated: true, completion: nil)
        
    }
       
    // cerrar sesion y redireccionar a pantalla login
    func salir(){
       UserDefaults.standard.removeObject(forKey: "userid")
       
       let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
       self.present(vista, animated: true, completion: nil)
    }
    
    
}
