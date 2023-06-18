//
//  ModeloOrdenes.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 5/6/23.
//

import Foundation



class ModeloOrdenes{
    
    var idOrden: Int
    var notaOrden: String
    var totalFormat: String
    var fechaOrden: String
    var notaCancelada: String
    var mensajeCupon: String
    var direccion: String
    var estado: String
    var estadoCancelada: Int
    var hayCupon: Int
    var hayPremio: Int
    var textoPremio: String
    
    init(idOrden: Int, notaOrden: String, totalFormat: String, fechaOrden: String, notaCancelada: String, mensajeCupon: String, direccion: String, estado: String, estadoCancelada: Int, hayCupon: Int, hayPremio: Int, textoPremio: String) {
        self.idOrden = idOrden
        self.notaOrden = notaOrden
        self.totalFormat = totalFormat
        self.fechaOrden = fechaOrden
        self.notaCancelada = notaCancelada
        self.mensajeCupon = mensajeCupon
        self.direccion = direccion
        self.estado = estado
        self.estadoCancelada = estadoCancelada
        self.hayCupon = hayCupon
        self.hayPremio = hayPremio
        self.textoPremio = textoPremio
    }
    
    func getHayCupon() -> Int {
        return hayCupon
    }
    
    func getEstadoCancelada() -> Int {
        return estadoCancelada
    }
    
    func getIdOrden() -> Int {
        return idOrden
    }
    
    func getNotaOrden() -> String {
        return notaOrden
    }
    
    func getTotalOrden() -> String {
        return totalFormat
    }
    
    func getFechaOrden() -> String {
        return fechaOrden
    }
    
    func getNotaCancelada() -> String {
        return notaCancelada
    }
    
    func getMensajeCupon() -> String {
        return mensajeCupon
    }
    
    func getDireccion() -> String {
        return direccion
    }
    
    func getEstado() -> String {
        return estado
    }
    
    func getHayPremio() -> Int {
        return hayPremio
    }
    
    func getTextoPremio() -> String {
        return textoPremio
    }
    
}
