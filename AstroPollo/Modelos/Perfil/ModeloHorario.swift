//
//  ModeloHorario.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 29/5/23.
//

import Foundation


class ModeloHorario{
       
    var dia: Int
    var fecha: String
  
    
    init(dia: Int, fecha: String) {
         self.dia = dia
         self.fecha = fecha
    }
        
    
    func getDia() -> Int {
        return dia
    }
    
    func getFecha() -> String {
        return fecha
    }
    
  
    
}
