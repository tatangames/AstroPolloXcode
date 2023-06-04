//
//  ModeloCarrito.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 4/6/23.
//

import Foundation


class ModeloCarrito{
       
    var productoID: Int
    var nombre: String
    var cantidad: Int
    var imagen: String
    var precio: String
    var activo: Int
    var carritoid: Int
    var utiliza_imagen: Int
    var estadoLocal: Int
    var titulo: String
    var mensaje: String
       
    
    init(productoID: Int, nombre: String, cantidad: Int, imagen: String, precio: String, activo: Int,
         carritoid: Int, utiliza_imagen: Int, estadoLocal: Int, titulo: String, mensaje: String) {
        self.productoID = productoID
        self.nombre = nombre
        self.cantidad = cantidad
        self.imagen = imagen
        self.precio = precio
        self.activo = activo
        self.carritoid = carritoid
        self.utiliza_imagen = utiliza_imagen
        self.estadoLocal = estadoLocal
        self.titulo = titulo
        self.mensaje = mensaje
    }
        
    
    func getIdProducto() -> Int {
        return productoID
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getCantidad() -> Int {
        return cantidad
    }
        
    func getImagen() -> String {
        return imagen
    }
    
    func getPrecio() -> String {
        return precio
    }
    
    func getActivo() -> Int {
        return activo
    }
 
    func getCarritoID() -> Int {
        return carritoid
    }
    
    func getUtilizaImagen() -> Int {
        return utiliza_imagen
    }
    
    func getTitulo() -> String {
        return titulo
    }
    
    func getMensaje() -> String {
        return mensaje
    }
    
    func getEstadoLocal() -> Int {
        return estadoLocal
    }
    
}
