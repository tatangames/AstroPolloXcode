//
//  ModeloCategoriasPrincipal.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 31/5/23.
//

import Foundation


class ModeloCategoriasPrincipal{
       
    var id: Int
    var nombre: String
    var imagen: String
       
    
    init(id: Int, nombre: String, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.imagen = imagen
    }
        
    
    func getId() -> Int {
        return id
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getImagen() -> String {
        return imagen
        
    }
 
    
}
