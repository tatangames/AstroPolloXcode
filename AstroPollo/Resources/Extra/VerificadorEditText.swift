//
//  VerificadorEditText.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import Foundation


extension UserDefaults{
    
    func setValueIdUsuario(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "userid")
        }else{
            UserDefaults.standard.removeObject(forKey: "userid")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func getValueIdUsuario() -> String? {
        return UserDefaults.standard.value(forKey: "userid") as? String
    }
        
    //-----------

    func setValueCarritoBool(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "carritobool")
        }else{
            UserDefaults.standard.removeObject(forKey: "carritobool")
        }
           
        UserDefaults.standard.synchronize()
    }
       
    func getValueCarritoBool() -> String? {
        return UserDefaults.standard.value(forKey: "carritobool") as? String
    }
    
    //----------
    
    func setValueMapa(value: String?){
          if(value != nil){
              UserDefaults.standard.set(value, forKey: "mapa")
          }else{
              UserDefaults.standard.removeObject(forKey: "mapa")
          }
             
          UserDefaults.standard.synchronize()
      }
         
      func getValueMapa() -> String? {
          return UserDefaults.standard.value(forKey: "mapa") as? String
      }
    
    
    //----------
    
    func setValuePresentacion(value: String?){
          if(value != nil){
              UserDefaults.standard.set(value, forKey: "presentacion")
          }else{
              UserDefaults.standard.removeObject(forKey: "presentacion")
          }
             
          UserDefaults.standard.synchronize()
      }
         
      func getValuePresentacion() -> String? {
          return UserDefaults.standard.value(forKey: "presentacion") as? String
      }
    
    //----------
    
    func setValuePresentacionEncargo(value: String?){
          if(value != nil){
              UserDefaults.standard.set(value, forKey: "presentacion_encargo")
          }else{
              UserDefaults.standard.removeObject(forKey: "presentacion_encargo")
          }
             
          UserDefaults.standard.synchronize()
    }
     
    func getValuePresentacionEncargo() -> String? {
      return UserDefaults.standard.value(forKey: "presentacion_encargo") as? String
    }
    
    //--- mensaje para que presione la orden, para ver el estado.
    
    /*func setValueEstadoOrden(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "estadoorden")
        }else{
            UserDefaults.standard.removeObject(forKey: "estadoorden")
        }
           
        UserDefaults.standard.synchronize()
    }
       
    func getValueEstadoOrden() -> String? {
        return UserDefaults.standard.value(forKey: "estadoorden") as? String
    }*/
    
    
    
    
    
    
    
    
    
    //----------  AFILIADOS  --------
    
    func setValueIdUsuarioAfiliado(value: String?){
          if(value != nil){
              UserDefaults.standard.set(value, forKey: "useridafiliado")
          }else{
              UserDefaults.standard.removeObject(forKey: "useridafiliado")
          }
          
          UserDefaults.standard.synchronize()
      }
      
      func getValueIdUsuarioAfiliado() -> String? {
          return UserDefaults.standard.value(forKey: "useridafiliado") as? String
      }
    
    // nombre servicio
    func setValueNombreServicio(value: String?){
       if(value != nil){
           UserDefaults.standard.set(value, forKey: "nombreservicio")
       }else{
           UserDefaults.standard.removeObject(forKey: "nombreservicio")
       }
           
        UserDefaults.standard.synchronize()
    }
       
    func getValueNombreServicio() -> String? {
        return UserDefaults.standard.value(forKey: "nombreservicio") as? String
    }
    
    func setValuePosicionProducto(value: String?){
       if(value != nil){
           UserDefaults.standard.set(value, forKey: "posicionproducto")
       }else{
           UserDefaults.standard.removeObject(forKey: "posicionproducto")
       }
           
        UserDefaults.standard.synchronize()
    }
       
    func getValuePosicionProducto() -> String? {
        return UserDefaults.standard.value(forKey: "posicionproducto") as? String
    }
    
    
    //----------
    /*func setValueCarritoInfoBool(value: Bool?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "carritobool")
        }else{
            UserDefaults.standard.removeObject(forKey: "carritobool")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func getValueCarritoInfoBool() -> Bool? {
        return UserDefaults.standard.value(forKey: "carritobool") as? Bool
    }*/
}
