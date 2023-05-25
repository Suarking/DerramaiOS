//
//  Neighbour.swift
//  DerramaSPL
//
//  Created by Suar PL on 4/5/23.
//

import Combine
import SwiftUI

struct NeighbourView: View {
  @StateObject var viewModel = CommunitiesViewModel()

  @State private var nombreVecino = ""
  @State private var pisoVecino = ""
  @State private var letraVecino = ""
  @State private var telefonoVecino = ""
  @State private var nombreBuscaVecino = ""
    
    

  var body: some View {
    NavigationStack {
      VStack {
        VStack {
          HStack {
            Label("Vecinos", systemImage: "person.circle.fill")
              .padding()
              .font(.system(size: 21, weight: .bold))

            Image("logoapp")
              .resizable()
              .frame(width: 170, height: 60)
              .shadow(color: Color.black, radius: 5, x: 1, y: 1)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .padding(.leading, 66)
          }
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .font(.system(size: 28, weight: .semibold, design: .rounded))
          .foregroundColor(Color.black)
          .background(.ultraThinMaterial)
            
            if viewModel.selectedCommunityName == "" {
              VStack {
                Text("Selecciona antes una comunidad para comenzar")
                  .font(.system(size: 28, weight: .semibold, design: .rounded))
                  .padding(.top, 50)
              }
              .multilineTextAlignment(.center)
            } else {
              VStack {
                Text("Administrando vecinos de \(viewModel.selectedCommunityName)")
                  .font(.system(size: 28, weight: .semibold, design: .rounded))
                  .multilineTextAlignment(.center)
                  .padding(.vertical, 30)
              }
       
        Spacer()
        ScrollView {
          

            VStack(spacing: 0) {
              Divider()

              Label("Alta de Vecinos", systemImage: "person.crop.circle.fill.badge.plus")
                .symbolRenderingMode(.multicolor)
                .padding(.top, 10)
                .font(.system(size: 26))
              Divider()
                .frame(width: 200, height: 2)
                .overlay(.gray)

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
                  viewModel.showAlert = true

              }, label: {
                Text("Alta de Vecino")
              })
              
              .buttonStyle(.borderedProminent)
              .font(.system(size: 20, weight: .semibold))
              .padding()
              .tint(.green)
            }
        

            VStack(spacing: 0) {
              Divider()

              Label("Buscar Vecino", systemImage: "person.crop.circle.badge.questionmark.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 26))
                .padding(.top, 10)
              Divider()
                .frame(width: 200, height: 2)
                .overlay(.gray)

              TextField("Nombre de Vecino", text: $nombreBuscaVecino)
                .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
              Button(action: {
                Task {
                  viewModel.foundNeighbours = []
                  await viewModel.searchNeighbours(communityId: viewModel.selectedCommunityId, name: nombreBuscaVecino)
                
                }

              }, label: {
                Text("Buscar Vecino")
              })
              .buttonStyle(.borderedProminent)
              .font(.system(size: 20, weight: .semibold))
              .padding()
            }
            .navigationTitle("")
            VStack {
              if viewModel.foundNeighbours.count == 0 {
                Text("No hay vecinos encontrados")
              } else {
                ForEach(viewModel.foundNeighbours, id: \._id) { neighbour in
                  VStack {
                    Divider()
                    VStack {
                      Label("\(neighbour.nombre)", systemImage: "person.crop.square.filled.and.at.rectangle.fill")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }

                    Divider()
                    VStack(alignment: .leading) {
                      Text("Piso: " + String(neighbour.piso))
                        .padding(.top, 10)
                      Text("Letra: \(neighbour.letra)")
                      Text("Teléfono: " + String(neighbour.telefono))
                        .padding(.bottom, 10)
                      Divider()
                    }
                    .padding(.leading, 80)

                    Button(action: {
                      viewModel.editIdVecino = neighbour._id
                      viewModel.editRevVecino = neighbour._rev
                      viewModel.editTablaVecino = neighbour.tabla
                      viewModel.editPisoVecino = String(neighbour.piso)
                      viewModel.editLetraVecino = neighbour.letra
                      viewModel.editNombreVecino = neighbour.nombre
                      viewModel.editTelefonoVecino = String(neighbour.telefono)
                      viewModel.editComunidadVecino = neighbour.comunidad

                      // Ir a Vista EditNeighbour

                      viewModel.editViewActive = true
                    }) {
                      Text("Editar datos")
                    }
                    .navigationDestination(isPresented: $viewModel.editViewActive, destination: { EditNeighbourView(viewModel: viewModel) })
                    
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 19, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .tint(.orange)
                    .padding(10)
                  }
                }
              }
            }
          }
            
            }
            Spacer()
            
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(LinearGradient(colors: [.white, .white, .white, .purple], startPoint: .bottomLeading, endPoint: .top))
      .onAppear {
        self.setToDefaults()
      }
    }
      
  }

  func addVecino() {
    if pisoVecino != "" && nombreVecino != "" && letraVecino != "" && telefonoVecino != "" {
      viewModel.addVecino.nombre = nombreVecino
      viewModel.addVecino.piso = Int(pisoVecino)!
      viewModel.addVecino.letra = letraVecino
      viewModel.addVecino.telefono = Int(telefonoVecino)!
      viewModel.addVecino.comunidad = viewModel.selectedCommunityId

      Task {
        do {
          try await viewModel.addNeighbour(addVecino: viewModel.addVecino)
        } catch {
          print("Error al añadir vecino")
        }
      }

    } else {
      print("Por favor, rellena todos los campos")
    }
  }

  func setToDefaults() {
    nombreVecino = ""
    letraVecino = ""
    pisoVecino = ""
    telefonoVecino = ""
    nombreBuscaVecino = ""
      
  }
}

struct NeighbourView_Previews: PreviewProvider {
  static var previews: some View {
    NeighbourView()
  }
}
