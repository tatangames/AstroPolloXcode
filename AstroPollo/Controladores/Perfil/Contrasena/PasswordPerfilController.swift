//
//  PasswordPerfilController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//


import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import Lottie


class PasswordPerfilController: UIViewController , UITextFieldDelegate{
    
    
    
    @IBOutlet weak var txtUsuario: UILabel!
    @IBOutlet weak var vistaPanel: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    
    @IBOutlet weak var edtPassword: CustomTextField!
    
    @IBOutlet weak var btnActualizar: UIButton!
    
    
    var styleAzul = ToastStilo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
        
        edtPassword.setupLeftImageView(image: UIImage(systemName: "lock.rectangle")!)
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)
        
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnActualizar.layer.cornerRadius = 18
        self.btnActualizar.clipsToBounds = true
        self.edtPassword.delegate = self
              
        peticionBuscarPerfil()
    }
    
    func peticionBuscarPerfil(){
                
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente
        ]
        
        let encodeURL = apiInformacionCliente
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      // INFORMACION DEL CLIENTE
                      
                      // usuario
                      let usuario =  json["usuario"].stringValue
                      
                      self.txtUsuario.text = "Usuario: " + usuario
                                                        
                      self.vistaPanel.isHidden = false
                      
                  }
                  else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionBuscarPerfil()
              }
        }
    }
    
    
    func retryPeticionBuscarPerfil(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarPerfil()
    }
    
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @IBAction func btnAccionActualizar(_ sender: Any) {
        verificar()
    }
    
    
    func verificar(){
        cerrarTeclado()
        
        
        // CONTRASEÑA ES REQUERIDA
        if(Validator().validarEntrada(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Contraseña es requerida")
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
        
        peticionCambiarContrasena()
    }
    
    
    func peticionCambiarContrasena(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //let idClienteusuario = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        let idCliente = "3"
                
        let params = [
            "id" : idCliente,
            "password": edtPassword.text ?? "",
        ]
        
        let encodeURL = apiActualizarPasswordPerfil
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                        
                         // CONTRASEÑA ACTUALIZADA
                         
                         self.alertaPasswordActualizada()
                       
                     }
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionCambiarContrasena()
              }
        }
        
        
    }
    
    
    
    func alertaPasswordActualizada(){
        
        let alert = UIAlertController(title: "Actualizada", message: "La contraseña se actualizo correctamente", preferredStyle: UIAlertController.Style.alert)
              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.salir()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func retryPeticionCambiarContrasena(){
         MBProgressHUD.hide(for: self.view, animated: true)
         peticionCambiarContrasena()
    }
    
    func salir(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == edtPassword {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

