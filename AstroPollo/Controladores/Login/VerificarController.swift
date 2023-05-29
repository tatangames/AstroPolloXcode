//
//  VerificarController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit
import Lottie
import MBProgressHUD
import SwiftyJSON
import Alamofire

class VerificarController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    @IBOutlet weak var edtCodigo: CustomTextField!
    @IBOutlet weak var btnVerificar: UIButton!
    
    var correo = ""
    
    
    var styleAzul = ToastStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
        
        
        edtCodigo.setupLeftImageView(image: UIImage(systemName: "lock.rectangle")!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnVerificar.layer.cornerRadius = 18
        self.btnVerificar.clipsToBounds = true
                                          
        
        self.edtCodigo.delegate = self
    }
    
    
    @IBAction func btnAccionVerificar(_ sender: Any) {
        
        // VERIFICAR CODIGO INGRESADO
        
        cerrarTeclado()
        
        if(Validator().validarEntradaRequerida(texto: edtCodigo.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Código es requerido")
            return
        }
        
        peticionEnviarCodigo()
    }
    
    
    func peticionEnviarCodigo(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
                
        let params = [
            "codigo" : edtCodigo.text ?? "",
            "correo": correo,
        ]
        
        let encodeURL = apiVerificarCodigoResetPassword
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                        
                         // se recibe el id de cliente tipo string
                         
                         let idcliente = json["id"].stringValue
                         
                         // PUEDE CAMBIAR LA CONTRASEÑA
                         self.pasarVistaResetPassword(idcliente: idcliente)
                       
                     } else if(codigo == 2){
                    
                       
                         // CODIGO INCORRECTO
                         self.mensajeToastAzul(mensaje: "Código incorrecto")
                         
                     }
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionEnviarCodigo()
              }
        }
    }
    
    
    func pasarVistaResetPassword(idcliente: String){
        
        let vistaSiguiente : CambiarPasswordController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CambiarPasswordController") as! CambiarPasswordController
        vistaSiguiente.idcliente = idcliente
        
        self.present(vistaSiguiente, animated: true, completion: nil)
        
    }
    
    
    func retryPeticionEnviarCodigo(){
         MBProgressHUD.hide(for: self.view, animated: true)
        peticionEnviarCodigo()
    }
    
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
       
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == edtCodigo {
            self.view.endEditing(true)
        }
        
        return true
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
