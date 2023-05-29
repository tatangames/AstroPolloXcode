//
//  RecuperacionCorreoController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit
import Lottie
import MBProgressHUD
import SwiftyJSON
import Alamofire

class RecuperacionController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    
    @IBOutlet weak var edtCorreo: CustomTextField!
    
    var styleAzul = ToastStyle()
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
                
        edtCorreo.setupLeftImageView(image: UIImage(systemName: "envelope.fill")!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnEnviar.layer.cornerRadius = 18
        self.btnEnviar.clipsToBounds = true
                                          
        
        self.edtCorreo.delegate = self
    }
    
    
    // VALIDACION DE CORREO ELECTRONICO
    func verificarEntrada(){
        
        cerrarTeclado()
       
        // CORREO ELECTRONICO ES REQUERIDO
        if(Validator().validarEntradaRequerida(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Correo es requerido")
            return
        }
        
        
        // VALIDAR CORREO ESTE ESCRITO CORRECTAMENTE
        if !Validator().validarCorreoElectronico(edtCorreo.text ?? "") {
            mensajeToastAzul(mensaje: "El correo no es Valido")
            return
        }
        
        peticionEnviarCorreo()
    }
    
    
    func peticionEnviarCorreo(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
                
        let params = [
            "correo": edtCorreo.text ?? "",
        ]
        
        let encodeURL = apiEnviarCorreoRecuperarContrasena
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                        
                         // CORREO ENVIADO
                         self.alertaCorreoEnviado()
                       
                     } else if(codigo == 2){
                    
                       
                         // CORREO NO ENCONTRADO
                         self.mensajeToastAzul(mensaje: "Correo no registrado")
                         
                         
                     }
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionEnviarCorreo()
              }
        }
        
    }
    
    func retryPeticionEnviarCorreo(){
         MBProgressHUD.hide(for: self.view, animated: true)
        peticionEnviarCorreo()
    }
    
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    
    
    func alertaCorreoEnviado(){
        
        let alert = UIAlertController(title: "Código Enviado", message: "Verificar su correo electrónico", preferredStyle: UIAlertController.Style.alert)
              
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
             
                 self.vistaIngresarCodigo()
                 
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func vistaIngresarCodigo(){
        
        
        let vistaSiguiente : VerificarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificarController") as! VerificarController
        vistaSiguiente.correo = edtCorreo.text ?? ""
        
        self.present(vistaSiguiente, animated: true, completion: nil)
        
        
    }
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    @IBAction func btnAccionEnviar(_ sender: Any) {
        verificarEntrada()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == edtCorreo {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vista, animated: true, completion: nil)
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
