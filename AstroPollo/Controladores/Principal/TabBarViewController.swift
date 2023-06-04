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
        
        
        // cambiara la vista cuando se hace una orden
        //let finalVC = self.viewControllers![0] as! ServiciosViewController //first view controller in the tabbar
        //finalVC.cambiarVista = cambiarVista
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
            
            
        }
        
    }
    

}
