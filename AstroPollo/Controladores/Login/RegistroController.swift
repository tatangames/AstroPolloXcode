//
//  RegistroController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import UIKit
import Lottie

class RegistroController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var lottieAnimacion: LottieAnimationView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var edtUsuario: CustomTextField!
    
    @IBOutlet weak var edtPassword: CustomTextField!
    
    @IBOutlet weak var edtCorreo: CustomTextField!
    
    @IBOutlet weak var btnRegistro: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        lottieAnimacion.contentMode = .scaleAspectFit
        lottieAnimacion.loopMode = .loop
        lottieAnimacion.play()
        
        
        edtUsuario.setupLeftImageView(image: UIImage(systemName: "person.fill")!)
        edtPassword.setupLeftImageView(image: UIImage(systemName: "lock.fill")!)
        edtCorreo.setupLeftImageView(image: UIImage(systemName: "envelope.fill")!)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)
        
        self.btnRegistro.layer.cornerRadius = 18
        self.btnRegistro.clipsToBounds = true
        
        
        self.edtUsuario.delegate = self
        self.edtPassword.delegate = self
        self.edtCorreo.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == edtUsuario){
                
            textField.resignFirstResponder()
            edtPassword.becomeFirstResponder()
        }
        else if textField == edtPassword {
            textField.resignFirstResponder()
            edtCorreo.becomeFirstResponder()
        }
        else if textField == edtCorreo {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
    
    
    @IBAction func btnAccionRegistro(_ sender: Any) {
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


