//
//  APINetwork.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import Foundation



let apiVersionApp = "1,0,0 IOS"



//let baseUrl:String = "http://165.227.196.71/api/"
//let baseUrlImagen: String = "http://165.227.196.71/storage/imagenes/"


let baseUrl:String = "http://192.168.1.29:8080/api/"
let baseUrlImagen: String = "http://192.168.1.29:8080/storage/imagenes/"

let apiIniciarSesion = baseUrl+"cliente/login"

let apiEnviarCorreoRecuperarContrasena = baseUrl+"cliente/enviar/codigo-correo"

let apiVerificarCodigoResetPassword = baseUrl+"cliente/verificar/codigo-correo-password"

let apiCambiarPasswordPerdida = baseUrl+"cliente/actualizar/password"

let apiRegistrarse = baseUrl+"cliente/registro"


