//
//  TabBarViewController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // CARGA VISTA PRINCIPAL DE SERVICIOS
    var cambiarVista = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.delegate = self
        
               
         let finalVC = self.viewControllers![0] as! PrincipalController
        finalVC.cambiarVistaOrdenesController = cambiarVista
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        
        
        if(selectedIndex == 0){
            
            // vista menu
            
        }
        else if(selectedIndex == 1){
            
            // vista carrito compras
            let finalVC = self.viewControllers![selectedIndex!] as! CarritoComprasController
            finalVC.recargarTouchBoton()
        }
        else{
            
            // vista ordenes controller
            let finalVC = self.viewControllers![selectedIndex!] as! OrdenesViewController
            finalVC.recargarTouchBoton()
        }
        
    }
    

}
