//
//  CommunitiesViewModel.swift
//  DerramaSPL
//
//  Created by Suar PL on 27/4/23.
//

import Foundation

final class CommunitiesViewModel : ObservableObject{
  
  @Published var token : String = ""
  @Published var currentUser : String = ""
  @Published var isLogged : Bool = false
  @Published var error : String = ""
  
  @Published var communities : [CommunityDataModel] =  []
  @Published var selectedCommunityName: String = ""
  @Published var selectedCommunityIndex: Int = 0
  
  @Published var addVecino = AddNeighbourModel(
  
    _rev: "",
    tabla: "VECINO",
    piso: 0,
    letra: "",
    nombre: "",
    telefono: 0,
    comunidad: ""
  
  
  )
  
  
  
  
  //============================================
  // MARK: ---------FUNCIONES API-----------
  //============================================
  
  //---------LOGIN--------
  
  func login(username: String, password: String) async {
    
    //Componiendo la request
    let urlString = "https://appstic.eu/login"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "accept")
    
    let parameters = ["username": username, "password": password]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    //Trayendo datos de la API de modo asíncrono
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      //Dispatch en principal
      DispatchQueue.main.async {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["token"] as? String {
          self.error = ""
          self.token = token
          self.isLogged = true
          print(self.token)
        } else {
          self.token = ""
          self.error = "Error al iniciar sesión"
          self.isLogged = false
          print ("Error al iniciar sesión")
        }
      }
    } catch {
      print (error.localizedDescription)
    }
  }
  
  func logout(){
    self.token = ""
    self.currentUser = ""
    self.communities = []
    self.isLogged = false
  }
  
  //--------API----Comunidades---------
  
  func getCommunities() async {
    let urlString = "https://appstic.eu/comunidad"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    if (self.token != ""){
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
      print (error.localizedDescription)
    }
  }
  
  func getCommunityIndex() {
    if let index = communities.firstIndex(where: { $0.nombre == selectedCommunityName }) {
      selectedCommunityIndex = index
      print("Índice de la comunidad seleccionada: \(selectedCommunityIndex)")
    } else {
      print("Comunidad no encontrada en el array communities")
    }
  }
  
  func addNeighbour(addVecino : AddNeighbourModel){
    
  }
  
}
