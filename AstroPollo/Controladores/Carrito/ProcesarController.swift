//
//  ProcesarController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 4/6/23.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class ProcesarController: UIViewController, UITextFieldDelegate {
    
    
    // VERSION APLICACION CUANDO ENVIAMOS UNA ORDEN
    
    var versionApp = "ios 1.0.0"
    
    
    
    
    @IBOutlet weak var textoTotalNormal: UILabel!
    @IBOutlet weak var txtTotalNormal: UILabel!
    
    @IBOutlet weak var textoTotalCupon: UILabel!
    @IBOutlet weak var txtTotalCupon: UILabel!
    
    @IBOutlet weak var vistaPantalla: UIView!
    @IBOutlet weak var btnCupon: UIButton!
        
    @IBOutlet weak var txtCupon: UILabel!
    @IBOutlet weak var txtPremioPuntos: UILabel!
    
    @IBOutlet weak var txtCliente: UILabel!
    @IBOutlet weak var txtDireccion: UILabel!
    
    @IBOutlet weak var edtNotas: TextFieldImagen!
    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
  
    @IBOutlet weak var stackTotalCupon: UIStackView!
    
    
    
    
    
    var seguroEnviar = true
    var minimo = 0 // bloqueo si falta minimo de consumo
    var minimoConsumo = ""
    
    
    var tengoCupon = 0
    var estadoBoton = 1 //para agregar cupon, 2: borrar cupon
    
    var cupon = ""
    var idfirabase = ""
    
    
    var actualizarCarrito = false
    
    
    var styleAzul = ToastStilo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnCupon.layer.cornerRadius = 18
        self.btnCupon.clipsToBounds = true
        
        self.btnConfirmar.layer.cornerRadius = 18
        self.btnConfirmar.clipsToBounds = true
        
        edtNotas.layer.cornerRadius = 8
        edtNotas.layer.borderWidth = 1.5
        edtNotas.layer.borderColor = UIColor.lightGray.cgColor
        edtNotas.borderStyle = .none
        
        self.edtNotas.delegate = self
        
        // ocultar texto de cupon
        
        textoTotalCupon.isHidden = true
        txtTotalCupon.isHidden = true
        
        
        peticionBuscar()
    }
    
    
    func peticionBuscar(){
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente
        ]
        
        let encodeURL = apiVerOrdenProcesar
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                if(codigo == 1){
                    
                  // CLIENTE SIN CARRITO PERO SERIA RARO ENTRAR AQUI
                    
                    self.salir()
                 
                }
                else if(codigo == 2){
                    
                    // DATOS ENCONTRADOR
                    
                    // 1: si puede ordenar
                    // 2: el minimo de consumo no alcanza
                    
                    let datoMinimo = json["minimo"].intValue
                    let datoTotal = json["total"].stringValue
                    let datoDireccion = json["direccion"].stringValue
                    let datoCliente = json["cliente"].stringValue
                    let datoMensaje = json["mensaje"].stringValue
                    let datoCupon = json["usacupon"].intValue

                        
                    self.minimo = datoMinimo
                    self.minimoConsumo = datoMensaje
                    
                    self.textoTotalNormal.text = "Total"
                    self.txtTotalNormal.text = datoTotal
                    
                    self.txtCliente.text = datoCliente
                    self.txtDireccion.text = datoDireccion
                    
                    // BOTON CUPON
                    
                    if(datoCupon == 1){
                        
                        self.btnCupon.isHidden = false
                        
                        // porque no ha colocado cupon estara oculto
                        self.txtCupon.isHidden = true
                        self.stackTotalCupon.isHidden = false
                        
                       // self.constraintVertical1.constant = 58
                        
                    }else{
                        
                        // AQUI NO SE USA CUPON                        
                        self.btnCupon.isHidden = true
                        self.txtCupon.isHidden = true
                        self.stackTotalCupon.isHidden = true
                        
                       // self.constraintVertical1.constant = 15
                    }
                    
                    
                    // TEXTO DE PREMIOS
                    // ahorita oculto 04/06/2023
                    
                    self.txtPremioPuntos.isHidden = true
                    
                    
                    // MOSTRAR VISTA
                    
                    self.vistaPantalla.isHidden = false
                    
                }
                
                else if(codigo == 3){
                    
                    // CARRITO DE COMPRAS NO ENCONTRADO
                    // raro que entre aqui, asi que solo salir
                    self.salir()
                }
                
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeSinConexion()
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryPeticionBuscar()
            }
        }
    }
    
    func retryPeticionBuscar(){
        MBProgressHUD.hide(for: self.view, animated: true)
        peticionBuscar()
    }
    
    func salir(){
        // actualizar pantalla carrito al regresar
        actualizarCarrito = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnAccionConfirmar(_ sender: Any) {
        verificar()
    }
    
    
    func verificar(){
                
        let alert = UIAlertController(title: "Confirmar Orden", message: "", preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 
                 self.peticionEnviarOrden()
            
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func peticionEnviarOrden(){
        
        if(seguroEnviar){
            seguroEnviar = false
            
            
            let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let params = [
                "clienteid": idCliente,
                "nota": edtNotas.text ?? "",
                "cupon": cupon,
                "aplicacupon": String(tengoCupon),
                "version": versionApp,
                "idfirebase": idfirabase
            ]
            
            let encodeURL = apiEnviarOrden
            
            AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
                
                switch response.result{
                case .success(let value):
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let json = JSON(value)
                    
                    let codigo = json["success"]
                    
                    self.seguroEnviar = true
                    
                    if(codigo == 1){
                                                
                        let datoTitulo = json["titulo"].stringValue
                        let datoMensaje = json["mensaje"].stringValue
                     
                        self.alertaErrorEnviarOrden(titulo: datoTitulo, mensaje: datoMensaje)
                    }
                    
                    // ORDEN ENVIADA
                    else if(codigo == 10){
                        
                        // PETICION NOTIFICACION A RESTAURANTE
                        
                        let datoTitulo = json["titulo"].stringValue
                        let datoMensaje = json["mensaje"].stringValue
                        
                        let datoOrden = json["idorden"].intValue
                        
                        self.peticionNotificacionRestaurante(idorden: datoOrden)
                        self.alertaOrdenEnviada(titulo: datoTitulo, mensaje: datoMensaje)
                    }
                  
                    
                    else{
                        self.seguroEnviar = true
                        self.mensajeSinConexion()
                    }
                    
                case .failure( _):
                    self.seguroEnviar = true
                    self.mensajeSinConexion()
                }
            }
        }
    }
    
    
    func peticionNotificacionRestaurante(idorden: Int){
        
        let params = [
            "id": String(idorden),
            
        ]
        
        let encodeURL = apiEnviarNotificacionRestaurante
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                               
                
                let json = JSON(value)
                
                
            case .failure( _): break
               
            }
        }
    }
    
    
    
    func alertaOrdenEnviada(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
                          
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
               self.salirOrdenEnviada()
           }))
           
           self.present(alert, animated: true, completion: nil)
    }
    
    func alertaErrorEnviarOrden(titulo: String, mensaje: String){
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
                          
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
                          
           }))
           
           self.present(alert, animated: true, completion: nil)
    }
    
    
    func salirOrdenEnviada(){
        
        let vista : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        vista.cambiarVista = true
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    func mensajeSinConexion(){
         mensajeToastAzul(mensaje: "Sin conexion")
         MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    
    @IBAction func btnCupon(_ sender: Any) {
        if(estadoBoton == 1){
            modalCupon()
        }else{
            modalBorrarCupon()
        }
    }
    
    
    func modalCupon(){
        let alert = UIAlertController(title: "Cupón", message: "Ingresar", preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        
        let cancel = UIAlertAction(title: "Salir", style: .default) { (alertAction) in }
               alert.addAction(cancel)
        
        let save = UIAlertAction(title: "Validar", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                self.cupon = textField.text ?? ""
                self.peticionVerificarCupon()
            } else {
                self.mensajeToastAzul(mensaje: "Cupón es requerido")
            }
        }

        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "Cupón"
            textField.textColor = .black
        }

        //Step : 4
        alert.addAction(save)
        //Cancel action
       
        //OR single line action
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })

        self.present(alert, animated:true, completion: nil)
    }
    
    func modalBorrarCupon(){
        let alert = UIAlertController(title: "Borrar Cupón", message: "", preferredStyle: UIAlertController.Style.alert)
               
           
           alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
           }))
           
           alert.addAction(UIAlertAction(title: "Si", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
              
               self.estadoBoton = 1
               self.tengoCupon = 0
            
               self.txtCupon.text = ""
               self.txtCupon.isHidden = true
               self.btnCupon.setTitle("Cupón", for: .normal)
               
               self.textoTotalCupon.text = ""
               self.txtTotalCupon.text = ""
               self.textoTotalCupon.isHidden = true
               self.txtTotalCupon.isHidden = true
               
               self.stackTotalCupon.isHidden = true
               
               // RECARGAR
               self.peticionBuscar()
            
           }))
           
           self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func peticionVerificarCupon(){
        
        
        let idCliente = UserDefaults.standard.getValueIdUsuario() ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = [
            "clienteid": idCliente,
            "cupon": cupon
        ]
        
        let encodeURL = apiVerificarCupon
        
        AF.request(encodeURL, method: .post, parameters: params).responseJSON{ (response) in
            
            switch response.result{
            case .success(let value):
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let json = JSON(value)
                
                let codigo = json["success"]
                
                // RETORNOS
                
                // 1- CARRITO DE COMPRAS NO ENCONTRADO
                // 1- CUPON NO VALIDO
                // 2- CUPON PRODUCTO GRATIS
                // 3- CUPON DESCUENTO DINERO
                // 4- CUPON DESCUENTO PORCENTAJE
                
                    if(codigo == 1){
                        
                        self.mensajeToastAzul(mensaje: "Cupón no válido")
                    }
                    
                    else if(codigo == 2){
                        
                                  
                    let datoTitulo = json["titulo"].stringValue
                    let datoMensaje = json["mensaje"].stringValue
                                            
                    self.alertaCuponValido(titulo: datoTitulo, mensaje: datoMensaje)
                }
                
                else if(codigo == 3){
                    
                    let datoTitulo = json["titulo"].stringValue
                    let datoMensaje = json["mensaje"].stringValue
                    let datoResta = json["resta"].stringValue
                    
                    self.textoTotalNormal.text = "Sub Total"
                    self.textoTotalCupon.text = "Total"
                    self.txtTotalCupon.text = datoResta
                    
                    self.textoTotalCupon.isHidden = false
                    self.txtTotalCupon.isHidden = false
                                            
                    self.alertaCuponValido(titulo: datoTitulo, mensaje: datoMensaje)
                }
                else if(codigo == 4){
                    
                    let datoTitulo = json["titulo"].stringValue
                    let datoMensaje = json["mensaje"].stringValue
                    let datoResta = json["resta"].stringValue
                    
                    self.textoTotalNormal.text = "Sub Total"
                    self.textoTotalCupon.text = "Total"
                    self.txtTotalCupon.text = datoResta
                    
                    self.textoTotalCupon.isHidden = false
                    self.txtTotalCupon.isHidden = false
                                            
                    self.alertaCuponValido(titulo: datoTitulo, mensaje: datoMensaje)
                }
                
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mensajeToastAzul(mensaje: "Cupón no válido")
                }
                
            case .failure( _):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.retryPeticionBuscar()
            }
        }
    }
    
        
    
    func alertaCuponValido(titulo: String, mensaje: String){
        self.tengoCupon = 1
        self.btnCupon.setTitle("Borrar", for: .normal)
        self.estadoBoton = 2
        
        self.txtCupon.text = mensaje
        self.txtCupon.isHidden = false
        
        self.stackTotalCupon.isHidden = false
            
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
           alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: {(action) in
               alert.dismiss(animated: true, completion: nil)
                     
           }))
           
           self.present(alert, animated: true, completion: nil)
    }
        
    
    var delegateProcesar: protocoloProcesarOrden!
    
    // pasar un bool para que no recargue el carrito de compras la pantalla
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        
        if(delegateProcesar != nil){
            delegateProcesar.actualizarVista(actualizar: actualizarCarrito)
        }
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
