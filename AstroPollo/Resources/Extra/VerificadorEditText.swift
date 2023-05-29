//
//  VerificadorEditText.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import Foundation


extension UserDefaults{
    
    // EXTENSION PARA GUARDAR DATOS APP
    
    
    
    
    
    
    
    // GUARDAR EL ID DEL CLIENTE
    func setValueIdUsuario(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "userid")
        }else{
            UserDefaults.standard.removeObject(forKey: "userid")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // OBTENER EL ID DEL CLIENTE
    func getValueIdUsuario() -> String? {
        return UserDefaults.standard.value(forKey: "userid") as? String
    }
        
   
    
    
    
    
    
    
    
    
    
    
    
    
    

    // GUARDAR ID PARA MOSTRAR AL CLIENTE COMO BORRAR EL CARRITO DE COMPRAS
    func setValueCarritoBool(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "carritobool")
        }else{
            UserDefaults.standard.removeObject(forKey: "carritobool")
        }
           
        UserDefaults.standard.synchronize()
    }
       
    // VERIFICAR SI YA SE EXPLICO AL CLIENTE COMO BORRAR EL CARRITO
    func getValueCarritoBool() -> String? {
        return UserDefaults.standard.value(forKey: "carritobool") as? String
    }
    
    
    
    
    
    
    
    
    
    
    
    
   
    
    
    // GUARDAR ID PARA MOSTRAR AL CLIENTE COMO UBICAR EL PUNTO DE MAPA
    func setValueMapa(value: String?){
          if(value != nil){
              UserDefaults.standard.set(value, forKey: "mapa")
          }else{
              UserDefaults.standard.removeObject(forKey: "mapa")
          }
             
          UserDefaults.standard.synchronize()
      }
         
    // VERIFICAR SI YA SE EXPLICO AL CLIENTE COMO UBICAR EL PUNTO EN EL MAPA
      func getValueMapa() -> String? {
          return UserDefaults.standard.value(forKey: "mapa") as? String
      }
    
  
    
    
    
    
    
    
    
  
}
