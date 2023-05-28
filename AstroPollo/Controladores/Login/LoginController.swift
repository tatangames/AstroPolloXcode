//
//  LoginController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var edtUsuario: CustomTextField!
    @IBOutlet weak var edtPassword: CustomTextField!
    
    @IBOutlet weak var btnRecuperarPassword: UIButton!
    @IBOutlet weak var btnRegistrarse: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var btLogin: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        edtUsuario.setupLeftImageView(image: UIImage(systemName: "person.fill")!)
        
        edtPassword.setupLeftImageView(image: UIImage(systemName: "lock.fill")!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        
        self.btLogin.layer.cornerRadius = 18
        self.btLogin.clipsToBounds = true
        
        
        self.edtUsuario.delegate = self
        self.edtPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtUsuario){
                
            textField.resignFirstResponder()
            edtPassword.becomeFirstResponder()
        }
        else if textField == edtPassword {
            //textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
    
    
    func verRegistro(){
        
        let vistaRegistro : RegistroController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistroController") as! RegistroController
        //vistaRegistro.telefono = telefono
        //vistaRegistro.deviceid = deviceid
        
        self.present(vistaRegistro, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func btnAccionLogin(_ sender: Any) {
        verRegistro()
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
