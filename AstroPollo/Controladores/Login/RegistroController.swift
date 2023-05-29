//
//  RegistroController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import UIKit
import Lottie
import MBProgressHUD
import SwiftyJSON
import Alamofire

class RegistroController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var lottieAnimacion: LottieAnimationView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var edtUsuario: CustomTextField!
    
    @IBOutlet weak var edtPassword: CustomTextField!
    
    @IBOutlet weak var edtCorreo: CustomTextField!
    
    @IBOutlet weak var btnRegistro: UIButton!
    
    var styleAzul = ToastStyle()
    var idfirebase = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        lottieAnimacion.contentMode = .scaleAspectFit
        lottieAnimacion.loopMode = .loop
        lottieAnimacion.play()
        
        
        edtUsuario.setupLeftImageView(image: UIImage(systemName: "person.fill")!)
        edtPassword.setupLeftImageView(image: UIImage(systemName: "lock.fill")!)
        edtCorreo.setupLeftImageView(image: UIImage(systemName: "envelope.fill")!)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnRegistro.layer.cornerRadius = 18
        self.btnRegistro.clipsToBounds = true
        
        
        self.edtUsuario.delegate = self
        self.edtPassword.delegate = self
        self.edtCorreo.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtUsuario){
                
            textField.resignFirstResponder()
            edtPassword.becomeFirstResponder()
        }
        else if textField == edtPassword {
            textField.resignFirstResponder()
            edtCorreo.becomeFirstResponder()
        }
        else if textField == edtCorreo {
            self.view.endEditing(true)
        }
        
        return true
    }
        
    
    @IBAction func btnAccionRegistro(_ sender: Any) {
        
        // VERIFICAR LOS INPUT
        verificar()
    }
    
    func verificar(){
        
        cerrarTeclado()
        
        
        // USUARIO ES REQUERIDO
        if(Validator().validarEntradaRequerida(texto: edtUsuario.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Usuario es requerido")
            return
        }
        
        // MINIMO 4 CARACTERES PARA CONTRASEÑA
        if(Validator().validarPasswordCaracteres(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Contraseña mínimo 4 caracteres")
            return
        }
        
        // MAXIMO 16 CARACTERES PARA CONTRASEÑA
        if(Validator().validarPasswordCaracteres(texto: edtPassword.text ?? "") == 2){
            mensajeToastAzul(mensaje: "Contraseña máximo 16 caracteres")
            return
        }
        
                               
        // SOLO VERIFICA CORREO SI LLEVA TEXTO
        if(Validator().verificarEntradaCorreo(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: "El correo no es Valido")
            return
        }
                        
        
        alertaHacerRegistro()
    }
    
    
    func peticionRegistrarse(){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
                
        let params = [
            "usuario": edtUsuario.text ?? "",
            "password": edtPassword.text ?? "",
            "correo": edtCorreo.text ?? "",
            "token_fcm": idfirebase,
            "version": apiVersionApp
        ]
        
        let encodeURL = apiRegistrarse
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                        
                         // USUARIO YA ESTA REGISTRADO
                         let titulo = json["titulo"].stringValue
                         let mensaje = json["mensaje"].stringValue
                       
                         self.alertaMensaje(titulo: titulo, mensaje: mensaje)
                         
                     } else if(codigo == 2){
                    
                         // CORREO YA REGISTRADO
                         let titulo = json["titulo"].stringValue
                         let mensaje = json["mensaje"].stringValue
                       
                         self.alertaMensaje(titulo: titulo, mensaje: mensaje)
                       
                     }
                     else if(codigo == 3){
                   
                        // REGISTRADO CORRECTAMENTE
                         
                         let idcliente = json["id"].stringValue
                        
                         self.pasarVistaMenu(idcliente: idcliente)
                     }
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionRegistrarse()
              }
        }
    }
    
    func pasarVistaMenu(idcliente : String){
        
        
        
        
        
    }
    
    
    func alertaHacerRegistro(){
        
        let alert = UIAlertController(title: "Registrarse", message: "Completar Registro", preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              self.peticionRegistrarse()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertaMensaje(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
                 
     
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func retryPeticionRegistrarse(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionRegistrarse()
    }
    
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
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


