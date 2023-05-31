//
//  ElegirCantidadController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class ElegirCantidadController: UIViewController, UITextFieldDelegate {
    
    var idproducto = ""
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var edtNotas: CustomTextField!
    @IBOutlet weak var txtCantidad: UILabel!
    @IBOutlet weak var pickerNumber: UIStepper!
    @IBOutlet weak var btnAgregar: UIButton!
    
    @IBOutlet weak var vistaPanel: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var txtPrecioCliente: UILabel!
    
    
    var styleAzul = ToastStyle()
    var utilizaNota = 0
    var usaNota = ""
    
    var precioFloat: Float = 0.0
    
    var cantidadElegida = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(red: 45, green: 88, blue: 156, alpha: 1)
        styleAzul.titleColor = .white
        
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 20, bottom: 40, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)
        
        self.edtNotas.delegate = self
        
        peticionBuscarProducto()
    }
    
    
    func peticionBuscarProducto(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let params = [
           "id": idproducto
        ]

        let encodeURL = apiInfoProductoIndividual

        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                      
              switch response.result{
                case .success(let value):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                                                   
                    let json = JSON(value)
                                     
                    let codigo = json["success"]
                    
                    if(codigo == 1){
                        
                     
                        
                        json["producto"].array?.forEach({ (dataArray) in
                                      
                            
                            // PRODUCTO ENCONTRADO
                                                  
                                                   
                            let nombre = dataArray["nombre"].stringValue
                            self.txtNombre.text = nombre
                                   
                            
                           if dataArray["descripcion"] == JSON.null {
                            
                               self.txtDescripcion.isHidden = true
                               
                           }else{
                               self.txtDescripcion.text = dataArray["descripcion"].stringValue
                           }
                         
                                                                         
                            let precio = dataArray["precio"].stringValue
                            self.txtPrecio.text = "Precio: $\(precio)"
                            
                            
                            
                            let usaImagen = dataArray["utiliza_imagen"].intValue
                            
                            
                            if usaImagen == 1{
                                
                                let imagen = dataArray["imagen"].stringValue
                                
                                
                                let union = baseUrlImagen + imagen
                                            
                                self.imgProducto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                                
                                
                                self.imgProducto.isHidden = false
                            }else{
                                self.imgProducto.isHidden = true
                            }
                            
                                                      
                       
                            
                            self.utilizaNota = dataArray["utiliza_nota"].intValue
                            
                            var nota = ""
                            if dataArray["nota"] == JSON.null {
                                // nada
                            }else{
                              nota = dataArray["nota"].stringValue
                            }
                            
                            self.usaNota = nota
                            
                            
                            self.precioFloat = Float(precio)!
                            
                            
                            self.txtPrecioCliente.text = "$" + precio
                            
                                                    
                            
                            self.btnAgregar.layer.cornerRadius = 10
                            self.btnAgregar.clipsToBounds = true
                            self.btnAgregar.setTitle("Agregar a la Orden",for: .normal)
                          
                            self.pickerNumber.minimumValue = 1
                            self.pickerNumber.maximumValue = 50
                            self.pickerNumber.value = 1
                        })
                        
                        
                        self.vistaPanel.isHidden = false
                        
                                             
                    } else{
                       MBProgressHUD.hide(for: self.view, animated: true)
                       self.mensajeToastAzul(mensaje: "Sin conexión")
                    }
          
                case .failure( _):
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.retryPeticionBuscarProducto()
                }
          }
    }
    
    
    func retryPeticionBuscarProducto(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscarProducto()
    }
    
    
    func mensajeToastAzul(mensaje: String){
       self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    func mensajeToastVerde(mensaje: String){
       self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @IBAction func btnAccionAgregar(_ sender: Any) {
        
        verificarIngreso()
    }
    
    
    func verificarIngreso(){
        
        let nn = edtNotas.text ?? ""
        
        if(utilizaNota == 1){
            if(nn.isEmpty){
                alertaPersonalizado(titulo: "Nota requerida", mensaje: "\(usaNota)")
                return
            }
        }
        
        peticionAgregarProducto()
    }
    
    func peticionAgregarProducto(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let idCliente = "3"

        let params = [
           "clienteid": idCliente,
           "productoid": String(idproducto),
           "cantidad": String(cantidadElegida),
           "notaproducto": edtNotas.text ?? ""
        ]

        let encodeURL = apiAgregarProductoCarrito

        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                      
              switch response.result{
                case .success(let value):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                                                   
                    let json = JSON(value)
                                     
                    let codigo = json["success"]
                  
                  
                        // REGLAS
                  
                        // REGLA 1: cliente no tiene direccion
                        // REGLA 2: producto debe estar activo
                        // REGLA 3: sub categoria debe estar activo
                        // REGLA 4: la categoria del producto debe estar activo
                        // REGLA 5: categoria si utiliza horario debe estar disponible
                  
                                      
                    if(codigo == 1){
                        
                     
                        let titulo = json["titulo"].stringValue
                        let mensaje = json["mensaje"].stringValue
                      
                        self.alertaPersonalizado(titulo: titulo , mensaje: mensaje)
                    }
                  else if(codigo == 2){
                      
                   
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                    
                      self.alertaPersonalizado(titulo: titulo , mensaje: mensaje)
                  }
                  
                  else if(codigo == 3){
                      
                   
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                    
                      self.alertaPersonalizado(titulo: titulo , mensaje: mensaje)
                  }
                  
                  else if(codigo == 4){
                      
                   
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                    
                      self.alertaPersonalizado(titulo: titulo , mensaje: mensaje)
                  }
                  
                  else if(codigo == 5){
                      
                   
                      let titulo = json["titulo"].stringValue
                      let mensaje = json["mensaje"].stringValue
                    
                      self.alertaPersonalizado(titulo: titulo , mensaje: mensaje)
                  }
                  else if(codigo == 6){
                      
                      self.productoGuardado()
                      
                  }
                  
                  else{
                       MBProgressHUD.hide(for: self.view, animated: true)
                       self.mensajeToastAzul(mensaje: "Sin conexión")
                    }
          
                case .failure( _):
                    MBProgressHUD.hide(for: self.view, animated: true)
                  self.mensajeToastAzul(mensaje: "Sin conexión")
                }
          }        
    }
    
    
    
    func productoGuardado(){
        
        self.mensajeToastVerde(mensaje: "Agregado")
       
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func alertaPersonalizado(titulo: String, mensaje: String){
                
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
               
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
                
           }))
               
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func pickerCantidad(_ stepper: UIStepper) {
                       
       cantidadElegida = Int(stepper.value)
       // agregar 2 decimales
       let total = precioFloat * Float(stepper.value)
       let precioFinal = (String(format:"%.02f", total))
        
       txtCantidad.text = "\(Int(stepper.value))"
        
       txtPrecioCliente.text = "$" + precioFinal
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtNotas){
                
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
