//
//  VerificarController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit
import Lottie

class VerificarController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaAnimacion: LottieAnimationView!
    @IBOutlet weak var edtCodigo: CustomTextField!
    @IBOutlet weak var btnVerificar: UIButton!
    
    
    var styleAzul = ToastStyle()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaAnimacion.contentMode = .scaleAspectFit
        vistaAnimacion.loopMode = .loop
        vistaAnimacion.play()
        
        
        edtCodigo.setupLeftImageView(image: UIImage(systemName: "lock.rectangle")!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
               view.addGestureRecognizer(tapGesture)

        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        self.btnVerificar.layer.cornerRadius = 18
        self.btnVerificar.clipsToBounds = true
                                          
        
        self.edtCodigo.delegate = self
        
    }
    
    
    @IBAction func btnAccionVerificar(_ sender: Any) {
        
        let vista : CambiarPasswordController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CambiarPasswordController") as! CambiarPasswordController
        self.present(vista, animated: true, completion: nil)
        
        
        
      
    }
    
    @IBAction func btnAtras(_ sender: Any) {
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == edtCodigo {
            self.view.endEditing(true)
        }
        
        return true
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
