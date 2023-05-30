//
//  ModeloDirecciones.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import Foundation


class ModeloDirecciones{
       
    var id: Int
    var nombre: String
    var direccion: String
    var punto_referencia: String
    var seleccionado: Int
    var telefono: String
      
    
    init(id: Int, nombre: String, direccion: String, punto_referencia: String, seleccionado: Int, telefono: String) {
        self.id = id
        self.nombre = nombre
        self.direccion = direccion
        self.punto_referencia = punto_referencia
        self.seleccionado = seleccionado
        self.telefono = telefono
    }
        
    
    func getId() -> Int {
        return id
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getDireccion() -> String {
        return direccion
    }
    
    func getPuntoReferencia() -> String {
        return punto_referencia
    }
    
    func getSeleccionado() -> Int {
        return seleccionado
    }
    
    func getTelefono() -> String {
        return telefono
    }
    
  
    
}
