//
//  CommunityDataResponseModel.swift
//  DerramaSPL
//
//  Created by Suar PL on 27/4/23.
//

import Foundation

// MARK: - Modelo Comunidad
struct CommunityDataModel: Codable {
  let _id: String
  let _rev: String
  let nombre: String
  let direccion: String
  let presidente: String
  let correo: String
  let telefono: String
}
// MARK: - Modelo Editar Vecino
struct AddNeighbourModel: Codable {
  var _rev: String
  var tabla: String
  var piso: Int
  var letra: String
  var nombre: String
  var telefono: Int
  var comunidad: String
}

// MARK: - Modelo Añadir Vecino
struct AddAddNeighbourModel: Codable {
  var tabla: String
  var piso: Int
  var letra: String
  var nombre: String
  var telefono: Int
  var comunidad: String
}
// MARK: - Modelo Buscar Vecino
struct FoundDataNeighbourModel: Codable{
  var _id: String
  var _rev: String
  var tabla: String
  var piso: Int
  var letra: String
  var nombre: String
  var telefono: Int
  var comunidad: String
  
}
// MARK: - Modelo Avisos
struct FoundDataNotices: Codable{
  var _id: String
  var _rev: String
  var tabla: String
  var comunidad: String
  var texto: String
  var fecha: String
}

// MARK: - Modelo Reuniones
struct MeetingDataModel: Codable {
    var tabla, fecha, comunidad, nombre: String
    var vecinos: [Vecino]
}

// MARK: - Modelo Vecino
struct Vecino: Codable {
    var vecino: String?
    var asiste: Bool?
}

struct DeleteNeighborResponse: Codable {
    let message: String
}



