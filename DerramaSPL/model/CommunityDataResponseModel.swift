//
//  CommunityDataResponseModel.swift
//  DerramaSPL
//
//  Created by Suar PL on 27/4/23.
//

import Foundation
struct CommunityDataModel: Codable {
  let _id: String
  let _rev: String
  let nombre: String
  let direccion: String
  let presidente: String
  let correo: String
  let telefono: String
}

struct AddNeighbourModel: Codable {
  var _rev: String
  var tabla: String
  var piso: Int
  var letra: String
  var nombre: String
  var telefono: Int
  var comunidad: String
}

