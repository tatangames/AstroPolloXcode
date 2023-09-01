//
//  APINetwork.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 28/5/23.
//

import Foundation



// utilizado al registrarse
let apiVersionApp = "ios 1.0.8"




let baseUrl:String = "http://165.227.196.71/api/"
let baseUrlImagen: String = "http://165.227.196.71/storage/imagenes/"


//let baseUrl:String = "http://192.168.1.29:8080/api/"
//let baseUrlImagen: String = "http://192.168.1.29:8080/storage/imagenes/"

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

let apiRegistrarNuevaDireccion = baseUrl+"cliente/nueva/direccion"

let apiBuscarCarritoCompras = baseUrl+"cliente/carrito/ver/orden"

let apiBorrarCarrito = baseUrl+"cliente/carrito/borrar/orden"

let apiBorrarProductoCarrito = baseUrl+"cliente/carrito/eliminar/producto"

let apiInfoProductoCarritoFila = baseUrl+"cliente/carrito/ver/producto"

let apiActualizaProductoCarrito = baseUrl+"cliente/carrito/cambiar/cantidad"

let apiVerOrdenProcesar = baseUrl+"cliente/carrito/ver/proceso-orden"

let apiVerificarCupon = baseUrl+"cliente/verificar/cupon"

let apiEnviarOrden = baseUrl+"cliente/proceso/enviar/orden"

let apiEnviarNotificacionRestaurante = baseUrl+"cliente/proceso/orden/notificacion"


let apiVerListadoOrdenes = baseUrl+"cliente/ordenes/listado/activas"

let apiInforOrdenIndividual = baseUrl+"cliente/orden/informacion/estado"

let apiListadoProductosOrden = baseUrl+"cliente/listado/productos/ordenes"



let apiOcultarMiOrden = baseUrl+"cliente/ocultar/mi/orden"

let apiCancelarOrden = baseUrl+"cliente/proceso/cancelar/orden"

let apiVerMotorista = baseUrl+"cliente/orden/ver/motorista"

let apiCalificarOrden = baseUrl+"cliente/orden/completar/calificacion"



// ** PREMIOS **


let apiListadoPremios = baseUrl+"cliente/premios/listado"

let apiBorrarPremioSeleccionado = baseUrl+"cliente/premios/deseleccionar"

let apiSeleccionarPremio = baseUrl+"cliente/premios/seleccionar"



let apiEliminarCuentaCliente = baseUrl+"cliente/eliminacion/total"


let apiBuscarHistorial = baseUrl+"cliente/historial/listado/ordenes"


let apiEnviarProblema = baseUrl+"cliente/problema/aplicacion/nota"
