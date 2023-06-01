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

let apiHorarioRestaurante = baseUrl+"cliente/informacion/restaurante/horario"

let apiInformacionCliente = baseUrl+"cliente/informacion/personal"

let apiActualizarPasswordPerfil = baseUrl+"cliente/perfil/actualizar/contrasena"

let apiActualizarCorreo = baseUrl+"cliente/actualizar/correo"

let apiListadoDirecciones = baseUrl+"cliente/listado/direcciones"

let apiSeleccionarDireccion = baseUrl+"cliente/direcciones/elegir/direccion"

let apiBorrarDireccion = baseUrl+"cliente/eliminar/direccion/seleccionada"

let apiListaDePoligonos = baseUrl+"cliente/listado/zonas/poligonos"

let apiCategoriasTodas = baseUrl+"cliente/listado/todas/categorias"

let apiProductosListadoMenu = baseUrl+"cliente/listado/productos/servicios"

let apiInfoProductoIndividual = baseUrl+"cliente/informacion/producto/individual"

let apiAgregarProductoCarrito = baseUrl+"cliente/carrito/producto/agregar"

let apiObtenerMenuPrincipal = baseUrl+"cliente/lista/servicios-bloque"

