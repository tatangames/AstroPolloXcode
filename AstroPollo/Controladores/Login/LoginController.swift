//
//  LoginController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class LoginController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var edtUsuario: CustomTextField!
    @IBOutlet weak var edtPassword: CustomTextField!
    @IBOutlet weak var btnRecuperarPassword: UIButton!
    @IBOutlet weak var btnRegistrarse: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btLogin: UIButton!
    var styleAzul = ToastStyle()
    
    
    var idfirebase = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        edtUsuario.setupLeftImageView(image: UIImage(systemName: "person.fill")!)
        edtPassword.setupLeftImageView(image: UIImage(systemName: "lock.fill")!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btLogin.layer.cornerRadius = 18
        self.btLogin.clipsToBounds = true
     
        self.edtUsuario.delegate = self
        self.edtPassword.delegate = self
        
        
        
        
        
        
        
    }

   
    
    @IBAction func btnAccionPassOlvidada(_ sender: Any) {
        let vistaSiguiente : RecuperacionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecuperacionController") as! RecuperacionController
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnAccionLogin(_ sender: Any) {
       
        pasarPantallaMenu()
        
       cerrarTeclado()
        
        // USAURIO ES REQUERIDO
        if(Validator().validarEntradaRequerida(texto: edtUsuario.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Usuario es requerido")
            return
        }
        
        // CONTRASEÑA ES REQUERIDO
        if(Validator().validarEntradaRequerida(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Contraseña es requerida")
            return
        }
        
        peticionIniciarSesion()
    }
    
    
    
    func peticionIniciarSesion(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
                
        let params = [
            "usuario": edtUsuario.text ?? "",
            "password": edtPassword.text ?? "",
            "idfirebase": idfirebase
        ]
        
        let encodeURL = apiIniciarSesion
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                         // USUARIO BLOQUEADO
                         let titulo = json["titulo"].stringValue
                         let mensaje = json["mensaje"].stringValue
                       
                         self.alertaMensaje(titulo: titulo , mensaje: mensaje)
                     } else if(codigo == 2){
                    
                         // INICIO DE SESION
                         let idcliente = json["id"].intValue
                         UserDefaults.standard.setValueIdUsuario(value: String(idcliente))
                         
                         self.pasarPantallaMenu()
                     } else if(codigo == 3){
                      
                         // CONTRASEÑA INCORRECTA
                         self.mensajeToastAzul(mensaje: "Datos incorrectos")
                      
                     } else if(codigo == 4){
                       
                         // USUARIO NO ENCONTRADO
                         self.mensajeToastAzul(mensaje: "Datos incorrectos")
                     
                     }
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.reintentoIniciarSesion()
              }
        }
    }
    
    
    
    func pasarPantallaMenu(){
        
        
        let vista : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        self.present(vista, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtUsuario){
                
            textField.resignFirstResponder()
            edtPassword.becomeFirstResponder()
        }
        else if textField == edtPassword {
            //textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
    }
    
    
    func verRegistro(){
        let vistaRegistro : RegistroController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistroController") as! RegistroController
        vistaRegistro.idfirebase = idfirebase
        
        self.present(vistaRegistro, animated: true, completion: nil)
    }
    
    
    func alertaMensaje(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
             
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func reintentoIniciarSesion(){
         MBProgressHUD.hide(for: self.view, animated: true)
         peticionIniciarSesion()
    }
    
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
       
    
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    // OPCIONES PARA OCULTAR TECLADO
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView?.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView?.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

