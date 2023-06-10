//
//  ModelosPremio.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 10/6/23.
//

import Foundation


class ModelosPremio{
    
    var id: Int
    var nombre: String
    var puntos: Int
    var activo: Int
    var seleccionado: Int
    
    
    init(id: Int, nombre: String, puntos: Int, activo: Int, seleccionado: Int) {
        self.id = id
        self.nombre = nombre
        self.puntos = puntos
        self.activo = activo
        self.seleccionado = seleccionado
    }
    
    
    func getId() -> Int {
        return id
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getPuntos() -> Int {
        return puntos
    }
    
    func getActivo() -> Int {
        return activo
    }
    
    func getSeleccionado() -> Int {
        return seleccionado
    }
    
    
}
    
