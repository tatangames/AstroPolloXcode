//
//  RegistrarNuevaDireccionController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 3/6/23.
//

import UIKit
import Lottie
import MBProgressHUD
import SwiftyJSON
import Alamofire

class RegistrarNuevaDireccionController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    
    
    @IBOutlet weak var edtNombre: TextFieldImagen!
    @IBOutlet weak var edtTelefono: TextFieldImagen!
    @IBOutlet weak var edtDireccion: TextFieldImagen!
    @IBOutlet weak var edtReferencia: TextFieldImagen!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var idzona = ""
    var latitud = ""
    var longitud = ""
    var latitudreal = ""
    var longitudreal = ""    
    
    var styleAzul = ToastStilo()
    
    
    @IBOutlet weak var btnRegistrar: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnRegistrar.layer.cornerRadius = 18
        self.btnRegistrar.clipsToBounds = true
        
        edtNombre.layer.cornerRadius = 8
        edtNombre.layer.borderWidth = 1.5
        edtNombre.layer.borderColor = UIColor.lightGray.cgColor
        edtNombre.borderStyle = .none
        
        edtTelefono.layer.cornerRadius = 8
        edtTelefono.layer.borderWidth = 1.5
        edtTelefono.layer.borderColor = UIColor.lightGray.cgColor
        edtTelefono.borderStyle = .none
        
        edtDireccion.layer.cornerRadius = 8
        edtDireccion.layer.borderWidth = 1.5
        edtDireccion.layer.borderColor = UIColor.lightGray.cgColor
        edtDireccion.borderStyle = .none
        
        edtReferencia.layer.cornerRadius = 8
        edtReferencia.layer.borderWidth = 1.5
        edtReferencia.layer.borderColor = UIColor.lightGray.cgColor
        edtReferencia.borderStyle = .none
        
        self.edtNombre.delegate = self
        self.edtTelefono.delegate = self
        self.edtDireccion.delegate = self
        self.edtReferencia.delegate = self
    }
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @IBAction func btnAccionRegistro(_ sender: Any) {
        
        verificar()
    }
    
    
    func verificar(){
        
        if(Validator().validarEntradaRequerida(texto: edtNombre.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Nombre es requerido")
            return
        }
        
        if(Validator().validarEntradaRequerida(texto: edtTelefono.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Teléfono es requerido")
            return
        }
        
        
        // VALIDAR TELEFONO 8 DIGITOS
        if(Validator().validar8Caracteres(texto: edtTelefono.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Teléfono requiere 8 dígitos")
            return
        }
        
        
        if(Validator().validarEntradaRequerida(texto: edtDireccion.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Dirección es requerido")
            return
        }
        
        // REFERENCIA ES REQUERIDA
        
        if(Validator().validarEntradaRequerida(texto: edtReferencia.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Referencia es requerido")
            return
        }
        
        
        preguntaRegistrar()
    }
    
    
    
    func preguntaRegistrar(){
        
        
        let alert = UIAlertController(title: "Guardar", message: nil, preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              self.peticionRegistrarse()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionRegistrarse(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
          
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "id": idCliente,
            "nombre": edtNombre.text ?? "",
            "direccion": edtDireccion.text ?? "",
            "punto_referencia": edtReferencia.text ?? "",
            "id_zona": idzona,
            "latitud": latitud,
            "longitud": longitud,
            "latitudreal": latitudreal,
            "longitudreal": longitudreal,
            "telefono": edtTelefono.text ?? ""
        ]
        
        let encodeURL = apiRegistrarNuevaDireccion
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                  
                  let codigo = json["success"]
                  
                  if(codigo == 1){
                      
                      // DIRECCION GUARDADA
                      
                      self.alertaGuardada()
                  }
                  else{
                      self.mensajeSinConexion()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.retryPeticionRegistrarse()
              }
        }
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    
    func retryPeticionRegistrarse(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionRegistrarse()
    }
    
    
    func alertaGuardada(){
        
        let alert = UIAlertController(title: "Dirección Guardada", message: "", preferredStyle: UIAlertController.Style.alert)
                
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.salir()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func salir(){
                
        let vista : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtNombre){
                
            textField.resignFirstResponder()
            edtTelefono.becomeFirstResponder()
        }
        else if textField == edtTelefono {
            textField.resignFirstResponder()
            edtDireccion.becomeFirstResponder()
            
        }
        else if textField == edtDireccion{
            textField.resignFirstResponder()
            edtReferencia.becomeFirstResponder()
        }
        else if textField == edtReferencia{
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        else{
            textField.resignFirstResponder()
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
