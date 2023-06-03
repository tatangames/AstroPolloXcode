//
//  ModeloProductoPopular.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 2/6/23.
//

import Foundation


class ModeloProductoPopular{
       
    var id: Int
    var imagen: String
    var nombre: String
    var utiliza_imagen: Int
    var precio: String
           
    
    init(id: Int, imagen: String, nombre:String, utiliza_imagen: Int, precio: String) {
        self.id = id
        self.imagen = imagen
        self.nombre = nombre
        self.utiliza_imagen = utiliza_imagen
        self.precio = precio
    }
        
    
    func getId() -> Int {
        return id
    }
    
    func getImagen() -> String {
        return imagen
    }
    
    func getNombre() -> String {
        return nombre
    }
 
    
    func getUtilizaImagen() -> Int {
        return utiliza_imagen
    }
    
    func getPrecio() -> String {
        return precio
    }
    
}

