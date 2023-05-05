//
//  CommunitiesViewModel.swift
//  DerramaSPL
//
//  Created by Suar PL on 27/4/23.
//

import Foundation

final class CommunitiesViewModel: ObservableObject {
  // Variables Login
  @Published var token: String = ""
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var currentUser: String = ""
  @Published var userRole: String = ""
  @Published var isLogged: Bool = false
  @Published var error: String = ""

  // Variables Comunidad
  @Published var communities: [CommunityDataModel] = []
  @Published var selectedCommunityName: String = ""
  @Published var selectedCommunityIndex: Int = 0
  @Published var selectedCommunityId: String = ""

  // Vecino anyadido
  @Published var addVecino = AddNeighbourModel(
    _rev: "",
    tabla: "VECINO",
    piso: 0,
    letra: "",
    nombre: "",
    telefono: 0,
    comunidad: ""
  )

  // Vecinos encontrados
  @Published var foundNeighbours: [FoundDataNeighbourModel] = []
  
  
  //Vecino a editar
  @Published var editVecino =  AddNeighbourModel(
    _rev: "",
    tabla: "VECINO",
    piso: 0,
    letra: "",
    nombre: "",
    telefono: 0,
    comunidad: ""
  )
  
  
  @Published var editViewActive : Bool = false
  
  //============================================

  // MARK: - --------FUNCIONES API-----------

  //============================================

  // LOGIN

  func login(username: String, password: String) async {
    // Componiendo la request
    let urlString = "https://appstic.eu/login"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "accept")

    let parameters = ["username": username, "password": password]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    // Trayendo datos de la API de modo asíncrono
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      // Dispatch en principal
      DispatchQueue.main.async {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["token"] as? String {
          self.error = ""
          self.token = token
          self.isLogged = true
          print(self.token)
          self.currentUser = username
          self.checkUserRole()
        } else {
          self.token = ""
          self.error = "Error al iniciar sesión"
          self.isLogged = false
          print("Error al iniciar sesión")
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  //ROL DE USUARIO
  func checkUserRole() {
    if (self.currentUser=="bec1" || self.currentUser=="bec2" || self.currentUser=="bec3"){
      self.userRole = "ADMIN"
    }else{
      self.userRole = "Vecino"
    }
  }

  // LOGOUT
  func logout() {
    token = ""
    currentUser = ""
    communities = []
    isLogged = false
    token = ""
    currentUser = ""
    communities = []
    selectedCommunityName = ""
    selectedCommunityIndex = 0
    addVecino.letra = ""
    addVecino.piso = 0
    addVecino.nombre = ""
    addVecino.telefono = 0
    addVecino.comunidad = ""
    isLogged = false
    foundNeighbours = []
  }

  // --------API----Comunidades---------

  // OBTENER COMUNIDADES
  func getCommunities() async {
    let urlString = "https://appstic.eu/comunidad"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    if token != "" {
      request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    }
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let decoder = JSONDecoder()
      let communities = try decoder.decode([CommunityDataModel].self, from: data)
      DispatchQueue.main.async {
        self.communities = communities
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  // OBTENER ÍNDICE E ID DE COMUNIDAD SELECCIONADA
  func getCommunityIndex() {
    if let index = communities.firstIndex(where: { $0.nombre == selectedCommunityName }) {
      selectedCommunityIndex = index
      print("Índice de la comunidad seleccionada: \(selectedCommunityIndex)")
      selectedCommunityId = communities[index]._id
      print(selectedCommunityId)

    } else {
      print("Comunidad no encontrada en el array communities")
    }
  }

  //================API VECINOS==================

  // AÑADIR VECINO

  func addNeighbour(addVecino: AddNeighbourModel) {
  }

  // OBTENER VECINOS

  func searchNeighbours(communityId: String, name: String) async {
    let url = URL(string: "https://appstic.eu/vecino/\(communityId)/\(name)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let decoder = JSONDecoder()
      let foundNeighbours = try decoder.decode([FoundDataNeighbourModel].self, from: data)

      DispatchQueue.main.async {
        self.foundNeighbours = foundNeighbours
        print(self.foundNeighbours)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
