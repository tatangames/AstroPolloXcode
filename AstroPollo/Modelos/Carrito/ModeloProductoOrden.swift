//
//  ModeloProductoOrden.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 6/6/23.
//

import Foundation

class ModeloProductoOrden{
    
    var idOrdenDescrip: Int
    var cantidad: Int
    var nota: String
    var imagen: String
    var utilizaImagen: Int
    var precio: String
    var nombreProducto: String
    
    init(idOrdenDescrip: Int, cantidad: Int, nota: String, imagen: String, utilizaImagen: Int, precio: String, nombreProducto: String) {
        self.idOrdenDescrip = idOrdenDescrip
        self.cantidad = cantidad
        self.nota = nota
        self.imagen = imagen
        self.utilizaImagen = utilizaImagen
        self.precio = precio
        self.nombreProducto = nombreProducto
    }
    
    
    func getIdOrdenDescrip() -> Int {
        return idOrdenDescrip
    }
    
    func getCantidad() -> Int {
        return cantidad
    }
    
    func getUtilizaImagen() -> Int {
        return utilizaImagen
    }
    
    func getNota() -> String {
        return nota
    }
    
    func getImagen() -> String {
        return imagen
    }
    
    func getPrecio() -> String {
        return precio
    }
    
    func getNombreProducto() -> String {
        return nombreProducto
    }
    
    
}

