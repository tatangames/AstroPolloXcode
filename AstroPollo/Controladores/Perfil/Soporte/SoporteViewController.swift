//
//  SoporteViewController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 31/8/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import Lottie


class SoporteViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var edtNota: UITextField!
    
    @IBOutlet weak var btnNota: UIButton!
    
    var styleAzul = ToastStilo()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnNota.layer.cornerRadius = 18
        self.btnNota.clipsToBounds = true
        
        
        edtNota.layer.cornerRadius = 8
        edtNota.layer.borderWidth = 1.5
        edtNota.layer.borderColor = UIColor.lightGray.cgColor
        edtNota.borderStyle = .none
        
        
        self.edtNota.delegate = self
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
      
        self.view.endEditing(true)
        return true
    }
    
    
    @IBAction func btnNota(_ sender: Any) {
        verificar()
    }
    
        
    
    func verificar(){
        
        cerrarTeclado()
        
        
        // NOTA ES REQUERIDO
        if(Validator().validarEntradaRequerida(texto: edtNota.text ?? "") == 1){
            mensajeToastAzul(mensaje: "Nota es requerido")
            return
        }
   
            
        enviarNota()
    }
    
    
    func enviarNota(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        
        let releaseApp = "releaseApp: \(UIApplication.release)"
        let buildApp = "buildApp: \(UIApplication.build)"
        let versionApp = "versionApp: \(UIApplication.version)"
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
                
        let params = [
            "clienteid": idCliente,
            "problema": edtNota.text ?? "",
            "manufactura": buildApp,
            "nombre": versionApp,
            "modelo": releaseApp,
        ]
        
        let encodeURL = apiEnviarProblema
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                        
            switch response.result{
              case .success(let value):
                  
                  MBProgressHUD.hide(for: self.view, animated: true)
                                                 
                  let json = JSON(value)
                                  
                  let codigo = json["success"]
                                     
                     if(codigo == 1){
                        
                      // NOTA ENVIADA
                         self.alertaMensaje()
                     }
                    
                     else{
                         // error de conexion
                         self.mensajeSinConexion()
                     }
        
              case .failure( _):
                  MBProgressHUD.hide(for: self.view, animated: true)
                  self.mensajeSinConexion()
              }
        }
    }
    
    
    
    func alertaMensaje(){
        
        edtNota.text = ""
        
        let msj = "Muchas gracias por compartir experiencias de la aplicación"
        
        let alert = UIAlertController(title: "Nota Recibida", message: msj, preferredStyle: UIAlertController.Style.alert)
                 
     
             alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
