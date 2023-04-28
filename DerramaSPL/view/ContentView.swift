//
//  ContentView.swift
//  DerramaSPL
//
//  Created by Suar PL on 26/4/23.
//

import Combine
import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = CommunitiesViewModel()

  @State var isLogged: Bool = false
  @State var username: String = ""
  @State var password: String = ""
  @State var selectedCommunity: String = ""
  @State var selectedCommunityid: String = ""

  // Vecino TextField
  @State var nombreVecino: String = ""
  @State var pisoVecino: String = ""
  @State var letraVecino: String = ""
  @State var telefonoVecino: String = ""

  var body: some View {
    if !isLogged {
      ZStack {
        Image("back")
          .resizable()
          .frame(width: 400, height: 900)

        VStack {
          Spacer()

          VStack(alignment: .leading) {
            Image ("logoapp")
              .resizable()
              .frame(width: 360, height: 120)
              .shadow(color: Color.black, radius: 5, x: 1, y: 1)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
          }
          VStack {
            VStack(spacing: 0) {
              (Text(Image(systemName: "person.fill"))
                + Text(" - Login"))
                .foregroundColor(.white)
                .frame(width: 360, height: 60)
                .font(.title)
                .shadow(color: Color.black, radius: 5, x: 1, y: 1)
                .padding(.top, 100)
              Divider()
                .frame(width: 200, height: 2)
                .overlay(.white)
            }

            TextField("Nombre de Usuario", text: $username)

              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)

              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.horizontal)
              .autocapitalization(.none)
            SecureField("Contraseña", text: $password)
              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
              .padding(.horizontal)

            Button("Iniciar Sesión") {
              Task {
                await viewModel.login(username: self.username, password: self.password)
                self.isLogged = viewModel.isLogged
              }

              viewModel.currentUser = username
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .padding()
          }
          .shadow(color: Color.black, radius: 5, x: 1, y: 1)
          .cornerRadius(30)

          Spacer()
          Spacer()
          Spacer()
        }

      }

    } else {
      TabView {
        Group {
          VStack {
            VStack {
              HStack {
                Label("Usuario", systemImage: "person.circle.fill")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 60)
              .font(.system(size: 36, weight: .semibold, design: .rounded))
              .foregroundColor(Color.black)
              .background(.ultraThinMaterial)
            }
            Spacer()
            VStack {
              Text("¡Bienvenido \(viewModel.currentUser)!")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .padding()
            }

            VStack {
              Spacer()
              Text("Actualmente logueado como Administrador")
                .padding()
              Spacer()
              Text("Selecciona una Comunidad en la pestaña Comunidades para empezar a gestionarla")
                .foregroundColor(.blue)
                .padding()
              Button(action: {
                viewModel.logout()
                self.isLogged = viewModel.isLogged
                self.username = ""
                self.password = ""
              }, label: {
                Text("Cerrar Sesión")
              })
                .buttonStyle(.borderedProminent)
                .padding()
            }

            Spacer()
            Spacer()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .tabItem {
            Label("Usuario", systemImage: "person.circle.fill")
          }
          .background(LinearGradient(colors: [.white, .white, .white, .blue], startPoint: .bottomLeading, endPoint: .top))

          VStack {
            VStack {
              HStack {
                Label("Comunidades", systemImage: "building.2.fill")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 60)
              .font(.system(size: 36, weight: .semibold, design: .rounded))
              .foregroundColor(Color.black)
              .background(.ultraThinMaterial)
            }

            VStack {
              if selectedCommunity != "" {
                Text("Administrando \(selectedCommunity)")
                  .font(.system(size: 28, weight: .semibold, design: .rounded))

              } else {
                Text("Selecciona una comunidad")
                  .font(.system(size: 28, weight: .semibold, design: .rounded))
              }
            }

            VStack {
              if selectedCommunity != "" {
                VStack {
                  Image("community")
                    .resizable()
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .frame(width: 250, height: 250)
                    .padding()

                  VStack(alignment: .leading) {
                    Text("Dirección: " + viewModel.communities[viewModel.selectedCommunityIndex].direccion)
                    Text("Teléfono: " + viewModel.communities[viewModel.selectedCommunityIndex].telefono)
                    Text("Presidente: " + viewModel.communities[viewModel.selectedCommunityIndex].presidente)
                    Text("E-Mail: " + viewModel.communities[viewModel.selectedCommunityIndex].correo)
                  }
                  .padding()
                }

              } else {
                VStack {
                  Image("communitybn")
                    .resizable()
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .frame(width: 250, height: 250)
                    .padding()
                }
              }
              Spacer()
              Picker("Selecciona Comunidad", selection: $viewModel.selectedCommunityName) {
                ForEach(viewModel.communities, id: \._id) { community in
                  Text(community.nombre).tag(community.nombre)
                }
              }
              .pickerStyle(.menu)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(30)
              .frame(height: 100)
              Button(action: {
                viewModel.getCommunityIndex()
                self.selectedCommunity = viewModel.selectedCommunityName

                print(viewModel.communities[viewModel.selectedCommunityIndex])

              }, label: {
                Text("Seleccionar Comunidad")
              })
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .onAppear {
              Task {
                await viewModel.getCommunities()
              }
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .tabItem {
            Label("Comunidades", systemImage: "building.2.fill")
          }
          .background(LinearGradient(colors: [.white, .white, .white, .red], startPoint: .bottomLeading, endPoint: .top))
          //==================VECINOS======================================

          VStack {
            VStack {
              HStack {
                Label("Vecinos", systemImage: "person.circle.fill")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 60)
              .font(.system(size: 36, weight: .semibold, design: .rounded))
              .foregroundColor(Color.black)
              .background(.ultraThinMaterial)
            }
            Spacer()
            ScrollView {
              if selectedCommunity == "" {
                VStack {
                  Text("Administrando selecciona una comunidad")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .padding()
                }
              } else {}
              VStack {
                Text("Administrando vecinos de \(selectedCommunity)")
                  .font(.system(size: 28, weight: .semibold, design: .rounded))
                  .padding()
              }
              VStack {
                Text("BLOQUE ALTA VECINOS")
                  .foregroundColor(.blue)
                  .padding()

                TextField("Nombre de Vecino", text: $nombreVecino)
                  .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                  .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                  .padding()
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding(.horizontal)
                  .autocapitalization(.none)
                TextField("Piso", text: $pisoVecino)
                  .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                  .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                  .padding()
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding(.horizontal)
                  .autocapitalization(.none)
                  // .keyboardType(.numberPad)
                  .onReceive(Just(pisoVecino)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                      self.pisoVecino = filtered
                    }
                  }
                TextField("Letra de piso", text: $letraVecino)
                  .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                  .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                  .padding()
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding(.horizontal)
                  .autocapitalization(.none)
                TextField("Teléfono", text: $telefonoVecino)
                  .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                  .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                  .padding()
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding(.horizontal)
                  .autocapitalization(.none)
                  // .keyboardType(.numberPad)
                  .onReceive(Just(telefonoVecino)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                      self.telefonoVecino = filtered
                    }
                  }

                Button(action: {
                  addVecino()

                }, label: {
                  Text("Alta de Vecino")
                })
                  .buttonStyle(.borderedProminent)
                  .padding()
              }

              VStack {
                Text("BLOQUE BÚSQUEDA VECINOS")
                  .foregroundColor(.blue)
                  .padding()
                Button(action: {
                  viewModel.logout()
                  self.isLogged = viewModel.isLogged
                  self.username = ""
                  self.password = ""
                }, label: {
                  Text("Buscar Vecino")
                })
                  .buttonStyle(.borderedProminent)
                  .padding()
              }

              Spacer()
              Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .tabItem {
            Label("Vecinos", systemImage: "person.3.fill")
          }
          .onAppear {
            if selectedCommunity != "" {
              selectedCommunityid = viewModel.communities[viewModel.selectedCommunityIndex]._id
              print("Id de comunidad seleccionada: \(selectedCommunityid)")
            }
          }
          .background(LinearGradient(colors: [.white, .white, .white, .purple], startPoint: .bottomLeading, endPoint: .top))
          Text("Settings")
            .tabItem {
              Label("Ajustes", systemImage: "gearshape")
            }
        }
        .toolbarColorScheme(.light, for: .tabBar)
      }
    }
  }

  func addVecino() {
    if pisoVecino != "" && nombreVecino != "" && letraVecino != "" && telefonoVecino != "" {
      viewModel.addVecino.nombre = nombreVecino
      viewModel.addVecino.piso = Int(pisoVecino)!
      viewModel.addVecino.letra = letraVecino
      viewModel.addVecino.telefono = Int(telefonoVecino)!
      viewModel.addVecino.comunidad = selectedCommunityid

      print(viewModel.addVecino)

    } else {
      print("Por favor, rellena todos los campos")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
