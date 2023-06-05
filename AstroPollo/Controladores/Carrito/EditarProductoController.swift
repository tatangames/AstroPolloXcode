//
//  EditarProductoController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 4/6/23.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class EditarProductoController: UIViewController, UITextFieldDelegate {
        
    var idcarritofila = ""    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var edtNotas: CustomTextField!
    @IBOutlet weak var txtCantidad: UILabel!
    @IBOutlet weak var pickerNumber: UIStepper!
    
    @IBOutlet weak var vistaPanel: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txtPrecioCliente: UILabel!
    @IBOutlet weak var btnEditar: UIButton!
    
    
    
    var styleToastAzul = ToastStilo()
    
    var utilizaNota = 0
    var usaNota = ""    
    var precioFloat: Float = 0.0
    var cantidadElegida = 1
    var seGuardoProducto = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        styleToastAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleToastAzul.titleColor = .white
          
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 20, bottom: 40, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)
        
        
        edtNotas.layer.cornerRadius = 8
        edtNotas.layer.borderWidth = 1.5
        edtNotas.layer.borderColor = UIColor.lightGray.cgColor
        edtNotas.borderStyle = .none
        
        self.edtNotas.delegate = self
        
        peticionBuscarProducto()
    }
        
    
    func peticionBuscarProducto(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        let params = [
           "clienteid": idCliente,
           "carritoid": String(idcarritofila)
        ]

        let encodeURL = apiInfoProductoCarritoFila

        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                      
              switch response.result{
                case .success(let value):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                                                   
                    let json = JSON(value)
                                     
                    let codigo = json["success"]
                    
                    if(codigo == 1){
                        
                        // INFORMACION DEL PRODUCTO
                                        
                            
                        // PRODUCTO ENCONTRADO
                                              
                       // nombre del producto
                       let nombre = json["producto"]["nombre"].stringValue
                       self.txtNombre.text = nombre
                        
                       
                       // descripcion del producto
                       if json["producto"]["descripcion"] == JSON.null {
                        
                           self.txtDescripcion.isHidden = true
                           
                       }else{
                           self.txtDescripcion.text = json["producto"]["descripcion"].stringValue
                       }
                                             
                        
                        // verificar si producto utiliza imagen
                        let usaImagen = json["producto"]["utiliza_imagen"].intValue
                        
                        if usaImagen == 1{
                            
                            let imagen = json["producto"]["imagen"].stringValue
                            
                            
                            let union = baseUrlImagen + imagen
                                        
                            self.imgProducto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefault"))
                            
                            
                            self.imgProducto.isHidden = false
                        }else{
                            self.imgProducto.isHidden = true
                        }
                        
                                                  
                   
                        // verificar si producto utiliza nota requerida
                        self.utilizaNota = json["producto"]["utiliza_nota"].intValue
                        
                        var nota = ""
                        if json["producto"]["nota"] == JSON.null {
                            // nada
                        }else{
                          nota = json["producto"]["nota"].stringValue
                        }
                        
                        self.usaNota = nota
                        
                                               
                        
                        // la nota del producto que el cliente escribio
                        var notaEdt = ""
                        if json["producto"]["nota_producto"] == JSON.null {
                            // nada
                        }else{
                          notaEdt = json["producto"]["nota_producto"].stringValue
                        }
                        
                        self.edtNotas.text = notaEdt
                        
                        
                        // esto setea la cantidad de producto que tiene cliente en carrito
                        let cantiEle = json["producto"]["cantidad"].intValue
                        self.cantidadElegida = cantiEle
                        self.txtCantidad.text = String(cantiEle)
                                                
                        
                        // se formatea el texto a tipo float
                        let precio = json["producto"]["precio"].stringValue
                        self.txtPrecio.text = "Precio $" + precio
                        let formatFloat = Float(precio)!
                        self.precioFloat = formatFloat
                        
                        
                        // agregar 2 decimales
                        let totalPro = formatFloat * Float(cantiEle)
                        let precioFinalCliente = (String(format:"%.02f", totalPro))
                         
                        // poner cuanto pagara por la cantidad elegida
                        self.txtPrecioCliente.text = "$" + precioFinalCliente
                        
                    
                        // seteo de botones
                        self.btnEditar.layer.cornerRadius = 10
                        self.btnEditar.clipsToBounds = true
                        self.btnEditar.setTitle("Actualizar",for: .normal)
                      
                        // seteo de picker number con la cantidad que tenia el carrito
                        self.pickerNumber.minimumValue = 1
                        self.pickerNumber.maximumValue = 50
                        self.pickerNumber.value = Double(Int(cantiEle)) // maximo podra tener 50
                  
                        // mostrar vista
                        self.vistaPanel.isHidden = false
                    }
                  
                      else if(codigo == 2){
                            // PRODUCTO NO ENCONTRADO, AUNQUE FUERA RARO ENTRAR AQUI
                          self.salir()
                      }
                    
                      else if(codigo == 3){
                          
                          // CARRITO DE COMPRAS VACIO
                          self.salir()
                          
                      }
                  
                     else{
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
    
    
    
    @IBAction func btnAccionEditar(_ sender: Any) {
               
        verificar()
    }
    
    
    func verificar(){
        
        
        let nn = edtNotas.text ?? ""
        
        if(utilizaNota == 1){
            if(nn.isEmpty){
                alertaPersonalizado(titulo: "Nota requerida", mensaje: "\(usaNota)")
                return
            }
        }
        
        peticionActualizar()
    }
    
    
    func alertaPersonalizado(titulo: String, mensaje: String){
                
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
               
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
                
           }))
               
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionActualizar(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        let params = [
           "clienteid": idCliente,
           "cantidad": String(cantidadElegida),
           "carritoid": String(idcarritofila),
           "nota": edtNotas.text ?? ""
        ]

        let encodeURL = apiActualizaProductoCarrito

        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                                      
              switch response.result{
                case .success(let value):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                                                   
                    let json = JSON(value)
                                     
                    let codigo = json["success"]
                    
                    if(codigo == 1){
                        
                       // PRODUCTO ACTUALIZADO
                    
                        self.salir()
                    }
                    else if(codigo == 2){
                          
                          // PRODUCTO NO ENCONTRADO PERO DECIR QUE FUE ACTUALIZADO
                          self.salir()
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeToastAzul(mensaje: "Sin conexión")
                    }
          
                case .failure( _):
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.retryPeticionActualizar()
                }
          }
    }
    
    
    func retryPeticionActualizar(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionActualizar()
    }
    
    
    
    func mensajeToastAzul(mensaje: String){
       self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleToastAzul)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtNotas){
                
            self.view.endEditing(true)
        }
               
        return true
    }
    
    
    
    
    @IBAction func pickerCantidad(_ stepper: UIStepper) {
                       
       cantidadElegida = Int(stepper.value)
       // agregar 2 decimales
       let total = precioFloat * Float(stepper.value)
       let precioFinal = (String(format:"%.02f", total))
        
       txtCantidad.text = "\(Int(stepper.value))"
        
       txtPrecioCliente.text = "$" + precioFinal
    }
    
    
    
    
    var delegate: protocoloCarrito!
   
    
    override func viewWillDisappear(_ animated: Bool) {
              
        if(delegate != nil){
            delegate.pasarDatoCarrito(actualizar: seGuardoProducto)
        }
    }
    
    func salir(){
        seGuardoProducto = true
        dismiss(animated: true, completion: nil)
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
