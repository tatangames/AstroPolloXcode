//
//  CalificarController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 6/6/23.
//

import Foundation
import Foundation
import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import AARatingBar

class CalificarController: UIViewController, UITextFieldDelegate{
    
    
    var idorden = 0
    
    
    @IBOutlet weak var barra: AARatingBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var edtNota: TextFieldImagen!
    @IBOutlet weak var btnGuardar: UIButton!
    
    var valorCalificacion = 5
    var styleAzul = ToastStilo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
      
        edtNota.layer.cornerRadius = 8
        edtNota.layer.borderWidth = 1.5
        edtNota.layer.borderColor = UIColor.lightGray.cgColor
        edtNota.borderStyle = .none
             
        edtNota.delegate = self
                
        barra.maxValue = 5
        barra.value = 5
        
        barra.ratingDidChange = { ratingValue in
            
            self.valorCalificacion = Int(self.barra.value)
            
            if(self.valorCalificacion == 0){
                self.valorCalificacion = 5
            }
        }
    }
    
    
    
    @IBAction func btnAccionGuardar(_ sender: Any) {
        
        cerrarTeclado()
      
        verificar()
    }
    
    func verificar(){
        
        let alert = UIAlertController(title: "Enviar Calificación", message: "", preferredStyle: UIAlertController.Style.alert)
                                                          
                 alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                     alert.dismiss(animated: true, completion: nil)
                 }))
                 
                 alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                     alert.dismiss(animated: true, completion: nil)
                     
                   self.peticionEnviar()
                 }))
        
         self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionEnviar(){
        
               
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "ordenid": String(idorden),
            "valor": String(valorCalificacion),
            "mensaje": edtNota.text ?? ""
        ]
        
        let encodeURL = apiCalificarOrden
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
              
                
                if(codigo == 1){
                    
                   // CALIFICADO
                                        
                    self.alertaCalificado()
                }
               
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryPeticionEnviar()
            }
        }
    }
    
    func alertaCalificado(){
                
        let alert = UIAlertController(title: "Orden Calificada", message: "Muchas Gracias", preferredStyle: UIAlertController.Style.alert)
                               
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
    
    
    
    func retryPeticionEnviar(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionEnviar()
    }
    
    func mensajeSinConexion(){
        MBProgressHUD.hide(for: self.view, animated: true)
        mensajeToastAzul(mensaje: "Sin conexion")
    }
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtNota){
            self.view.endEditing(true)
        }
                
        return true
    }
    
    
    // OPCIONES PARA OCULTAR TECLADO
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
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
    
    
    
