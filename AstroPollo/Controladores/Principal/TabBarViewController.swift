//
//  TabBarViewController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    // CARGA VISTA PRINCIPAL DE SERVICIOS
    var cambiarVista = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cambiara la vista cuando se hace una orden
        //let finalVC = self.viewControllers![0] as! ServiciosViewController //first view controller in the tabbar
        //finalVC.cambiarVista = cambiarVista
    }

}
