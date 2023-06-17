//
//  PerfilCorreoController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import Lottie



class PerfilCorreoController: UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    @IBOutlet weak var txtUsuario: UILabel!
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var edtCorreo: CustomTextField!
    @IBOutlet weak var vistaPanel: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var styleAzul = ToastStilo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
        
        edtCorreo.setupLeftImageView(image: UIImage(systemName: "envelope.fill")!)
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)
        
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnActualizar.layer.cornerRadius = 18
        self.btnActualizar.clipsToBounds = true
        self.edtCorreo.delegate = self
              
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
                      let correo = json["correo"].stringValue
                                            
                      self.txtUsuario.text = "Usuario: " + usuario
                      self.edtCorreo.text = correo
                                                        
                      self.vistaPanel.isHidden = false
                      
                  }
                  else{
                      self.mensajeSinConexion()
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
        
        cerrarTeclado()
        
        if(Validator().validarEntradaRequerida(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Correo es requerido")
            return
        }
        
        if !Validator().validarCorreoElectronico(edtCorreo.text ?? "") {
            mensajeToastAzul(mensaje: "El correo no es Valido")
            return
        }
        
        peticionActualizarCorreo()
    }
    
    
    func peticionActualizarCorreo(){
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente,
            "correo": edtCorreo.text ?? ""
        ]
        
        let encodeURL = apiActualizarCorreo
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      // CORREO ACTUALIZADO
                      self.alertaCorreoActualizada()
                      
                  }
                  else{
                      self.mensajeSinConexion()
                      MBProgressHUD.hide(for: self.view, animated: true)
                  }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionActualizarCorreo()
              }
        }
    }
    
    
    func retryPeticionActualizarCorreo(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionActualizarCorreo()
    }
    
    
    @IBAction func btnAtras(_ sender: Any) {        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func alertaCorreoActualizada(){
        
        let alert = UIAlertController(title: "Actualizado", message: "Correo se actualizo correctamente", preferredStyle: UIAlertController.Style.alert)
              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.salir()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
        
   
    
    func salir(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == edtCorreo {
            self.view.endEditing(true)
        }
        
        return true
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
