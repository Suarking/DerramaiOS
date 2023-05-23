//
//  CommunitiesViewModel.swift
//  DerramaSPL
//
//  Created by Suar PL on 27/4/23.
//

import Foundation

final class CommunitiesViewModel: ObservableObject {
  // MARK: - ===============VARIABLES GLOBALES=====================

  // MARK: - Variables Login

  @Published var token: String = ""
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var currentUser: String = ""
  @Published var userRole: String = ""
  @Published var isLogged: Bool = false
  @Published var error: String = ""

  // MARK: - Variables Comunidad

  @Published var communities: [CommunityDataModel] = []
  @Published var selectedCommunityName: String = ""
  @Published var selectedCommunityIndex: Int = 0
  @Published var selectedCommunityId: String = ""

  // MARK: - ------ VECINO -------

  // MARK: - Vecino anyadido

  @Published var addVecino = AddAddNeighbourModel(
    tabla: "VECINO",
    piso: 0,
    letra: "",
    nombre: "",
    telefono: 0,
    comunidad: ""
  )

  // MARK: - Vecinos encontrados

  @Published var foundNeighbours: [FoundDataNeighbourModel] = []

  // MARK: - Todos los vecinos

  @Published var allNeighbours: [FoundDataNeighbourModel] = []

  // MARK: - Vecinos convocados a la reunión

  @Published var meetNeighbours: [Vecino] = []

  // MARK: - Textfields Editar Vecino

  @Published var editIdVecino = ""
  @Published var editRevVecino = ""
  @Published var editTablaVecino = "VECINO"
  @Published var editPisoVecino = ""
  @Published var editTelefonoVecino = ""
  @Published var editNombreVecino = ""
  @Published var editLetraVecino = ""
  @Published var editComunidadVecino = ""

  // MARK: - Vecino a editar

  @Published var editVecino = AddNeighbourModel(
    _rev: "",
    tabla: "VECINO",
    piso: 0,
    letra: "",
    nombre: "",
    telefono: 0,
    comunidad: ""
  )

  // MARK: - Toggle Vista edición Vecino

  @Published var editViewActive: Bool = false

  // Noticias
  @Published var notices: [FoundDataNotices] = []

  // Alertas
  @Published var showAlert: Bool = false
  @Published var showSuccessAlert: Bool = false
  @Published var showErrorAlert: Bool = false

  // Reuniones
  @Published var foundMeetings: [MeetingDataModel] = []

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

  // ROL DE USUARIO
  func checkUserRole() {
    if currentUser == "bec1" || currentUser == "bec2" || currentUser == "bec3" {
      userRole = "ADMIN"
    } else {
      userRole = "Vecino"
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

  func addNeighbour(addVecino: AddAddNeighbourModel) async throws {
    let url = URL(string: "https://appstic.eu/vecino")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    let body = try JSONEncoder().encode(addVecino)
    request.httpBody = body

    let (data, response) = try await URLSession.shared.data(for: request)

    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode != 201 {
      print("Error al añadir vecino. Status code: \(httpResponse.statusCode)")
      return
    }

    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    if let message = json?["message"] as? String {
      print(message)
    }
  }

  // BUSCAR VECINOS

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

  // EDITAR VECINOS
  func updateNeighbour() async throws {
    let url = URL(string: "https://appstic.eu/vecino/\(editIdVecino)")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: Any] = [
      "_rev": editVecino._rev,
      "tabla": "VECINO",
      "piso": editVecino.piso,
      "letra": editVecino.letra,
      "nombre": editVecino.nombre,
      "telefono": editVecino.telefono,
      "comunidad": editVecino.comunidad,
    ]
    let jsonData = try JSONSerialization.data(withJSONObject: body)
    request.httpBody = jsonData

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let responseString = String(decoding: data, as: UTF8.self)
      print(responseString)
    } catch {
      print("Error updating neighbour: \(error.localizedDescription)")
    }
  }

  // ELIMINAR VECINO
  func deleteNeighbor() async {
    let url = URL(string: "https://appstic.eu/vecino/\(editIdVecino)?rev=\(editRevVecino)")!
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let responseString = String(decoding: data, as: UTF8.self)
      print(responseString)
    } catch {
      print("Error deleting neighbour: \(error.localizedDescription)")
    }
  }

  // OBTENER TODOS LOS VECINOS
  func getAllNeighbors() async {
    let url = URL(string: "https://appstic.eu/comunidad/vecinos/\(selectedCommunityId)")!

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("No se ha podido obtener la información de los vecinos")
        return
      }

      let neighbors = try JSONDecoder().decode([FoundDataNeighbourModel].self, from: data)

      DispatchQueue.main.async {
        self.allNeighbours = neighbors

        // Aprovechamos y sacamos modelo para convocar reuniones
        for neighbour in self.allNeighbours {
          let vecino = Vecino(vecino: neighbour._id, asiste: false)
          self.meetNeighbours.append(vecino)
          dump(self.meetNeighbours)
        }
      }

    } catch {
      DispatchQueue.main.async {
        print("Error en getNeighbors: \(error)")
      }
    }
  }

  //================API AVISOS==================

  // Obtener AVISOS
  func getNotifications() async {
    let url = URL(string: "https://appstic.eu/aviso/\(selectedCommunityId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let notices = try JSONDecoder().decode([FoundDataNotices].self, from: data)
      DispatchQueue.main.async {
        self.notices = notices
        dump(self.notices)
      }
    } catch {
      DispatchQueue.main.async {
        print("Error getting notifications: \(error.localizedDescription)")
      }
    }
  }

  func addAviso(comunidadID: String, texto: String, fecha: String) async {
    let url = URL(string: "https://appstic.eu/aviso")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
      "tabla": "AVISO",
      "comunidad": comunidadID,
      "texto": texto,
      "fecha": fecha,
    ]

    do {
      let jsonData = try JSONSerialization.data(withJSONObject: body)
      request.httpBody = jsonData

      let (data, _) = try await URLSession.shared.data(for: request)
      let response = try JSONDecoder().decode(AddAvisoResponse.self, from: data)

      DispatchQueue.main.async {
        print(response.message)
      }
    } catch {
      DispatchQueue.main.async {
        print("Error adding aviso: \(error.localizedDescription)")
      }
    }
  }

  // Reuniones
  func addMeeting(fecha: String, nombre: String, vecinos: [Vecino]) async {
    let url = URL(string: "https://appstic.eu/reunion")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    let newMeeting = MeetingDataModel(tabla: "REUNION",
                                      fecha: fecha,
                                      comunidad: "\(selectedCommunityId)",
                                      nombre: nombre,
                                      vecinos: vecinos)

    guard let jsonData = try? JSONEncoder().encode(newMeeting) else {
      print("Error encoding meeting data")
      return
    }

    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
        print("Error adding meeting")
        return
      }

      let jsonDecoder = JSONDecoder()
      let responseModel = try jsonDecoder.decode(AddMeetingResponse.self, from: data)
      print(responseModel.message)

      DispatchQueue.main.async {
        // Handle successful response
      }
    } catch {
      print("Error adding meeting: \(error)")
      DispatchQueue.main.async {
        // Handle error
      }
    }
  }

  func getMeetings() async {
    let url = URL(string: "https://appstic.eu/reunion/\(selectedCommunityId)")!

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
      do {
        guard let data = data else {
          throw NSError(domain: "com.example.app", code: 400, userInfo: [NSLocalizedDescriptionKey: "No se han podido obtener las reuniones"])
        }
        guard let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode) else {
          print("Error obteniendo reuniones")
          return
        }
        let meetings = try JSONDecoder().decode([MeetingDataModel].self, from: data)
        DispatchQueue.main.async {
          self.foundMeetings = meetings
          dump(self.foundMeetings)
        }

      } catch let error {
        print("Error en getMeetings: \(error)")
      }
    }.resume()
  }
}
