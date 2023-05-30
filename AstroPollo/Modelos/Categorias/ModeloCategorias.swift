//
//  ModeloCategorias.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 30/5/23.
//

import Foundation


class ModeloCategorias{
       
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
