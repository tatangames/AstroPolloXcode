//
//  ModeloBanner.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 31/5/23.
//


import Foundation


class ModeloBanner{
       
    var idProducto: Int
    var imagen: String
    var redireccionamiento: Int
       
    
    init(idProducto: Int, imagen: String, redireccionamiento: Int) {
        self.idProducto = idProducto
        self.imagen = imagen
        self.redireccionamiento = redireccionamiento
    }
        
    
    func getIdProducto() -> Int {
        return idProducto
    }
    
    func getRedireccionamiento() -> Int {
        return redireccionamiento
    }
    
    func getImagen() -> String {
        return imagen
    }
 
    
}
