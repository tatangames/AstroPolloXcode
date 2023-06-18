//
//  HistorialBotonFechaController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 17/6/23.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class HistorialBotonFechaController: UIViewController {
    
    
    @IBOutlet weak var edtDesde: UITextField!
    @IBOutlet weak var edtHasta: UITextField!
    @IBOutlet weak var btnBuscar: UIButton!
    
    var fechaDesde = ""
    var fechaHasta = ""
   
    var styleAzul = ToastStilo()
    
    let datePickerDesde = UIDatePicker()
    let datePickerHasta = UIDatePicker()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
                
        btnBuscar.layer.cornerRadius = 18
        btnBuscar.clipsToBounds = true
            
        createDatePicker()
    }
    
    
    func createToolbarDesde() -> UIToolbar{
        
        let toobar = UIToolbar()
        toobar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Seleccionar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dateChangeDesde))
        toobar.setItems([doneBtn], animated: true)
        
        return toobar
    }
    
    
    func createToolbarHasta() -> UIToolbar{
        
        let toobar = UIToolbar()
        toobar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Seleccionar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dateChangeHasta))
        toobar.setItems([doneBtn], animated: true)
        
        return toobar
    }
    
    
    func createDatePicker(){
        
        let loc = Locale(identifier: "es")
        self.datePickerDesde.locale = loc
        self.datePickerHasta.locale = loc
        
        datePickerDesde.preferredDatePickerStyle = .wheels
        datePickerDesde.datePickerMode = .date
        datePickerHasta.preferredDatePickerStyle = .wheels
        datePickerHasta.datePickerMode = .date
        
        datePickerDesde.maximumDate = Date()
        datePickerHasta.maximumDate = Date()
        
        edtDesde.textAlignment = .center
        edtDesde.inputView = datePickerDesde
        edtDesde.inputAccessoryView = createToolbarDesde()
        
        edtHasta.textAlignment = .center
        edtHasta.inputView = datePickerHasta
        edtHasta.inputAccessoryView = createToolbarHasta()
    }
    
    
    
    @objc func dateChangeDesde(){
        
        let dateFormatterEdt = DateFormatter()
        dateFormatterEdt.dateStyle = .medium
        dateFormatterEdt.timeStyle = .none
        
        let dateFormatterTexto = DateFormatter()
        dateFormatterTexto.dateStyle = .medium
        dateFormatterTexto.timeStyle = .none
                
        // formateo texto para servidor
        dateFormatterTexto.dateFormat = "yyyy-MM-dd"
        fechaDesde = dateFormatterTexto.string(from: datePickerDesde.date)
        
        dateFormatterEdt.locale = Locale(identifier: "es")
        dateFormatterEdt.dateFormat = "dd-MMMM-YYYY"
        self.edtDesde.text = dateFormatterEdt.string(from: datePickerDesde.date)
        
        
        self.view.endEditing(true)
    }
        
    @objc func dateChangeHasta(){
        
        
        let dateFormatterEdt = DateFormatter()
        dateFormatterEdt.dateStyle = .medium
        dateFormatterEdt.timeStyle = .none
        
        let dateFormatterTexto = DateFormatter()
        dateFormatterTexto.dateStyle = .medium
        dateFormatterTexto.timeStyle = .none
                
        // formateo texto para servidor
        dateFormatterTexto.dateFormat = "yyyy-MM-dd"
        fechaHasta = dateFormatterTexto.string(from: datePickerHasta.date)
        
        dateFormatterEdt.locale = Locale(identifier: "es")
        dateFormatterEdt.dateFormat = "dd-MMMM-YYYY"
        self.edtHasta.text = dateFormatterEdt.string(from: datePickerHasta.date)
        
                
        self.view.endEditing(true)
    }
    
    
 
    
    @IBAction func btnAccionBuscar(_ sender: Any) {
       
        
        if(fechaDesde.isEmpty){
            mensajeToastAzul(mensaje: "Feche Desde es requerida")
            return
        }
        
        if(fechaHasta.isEmpty){
            mensajeToastAzul(mensaje: "Feche Hasta es requerida")
            return
        }
         
        let vistaSiguiente : HistorialBusquedaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "HistorialBusquedaController") as! HistorialBusquedaController
        
        vistaSiguiente.fechaDesde = fechaDesde
        vistaSiguiente.fechaHasta = fechaHasta
                
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
   
    
    @IBAction func btnAtras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
