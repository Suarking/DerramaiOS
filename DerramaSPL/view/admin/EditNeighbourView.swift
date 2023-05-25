//
//  EditNeighbour.swift
//  DerramaSPL
//
//  Created by Suar PL on 6/5/23.
//

import Combine
import SwiftUI

struct EditNeighbourView: View {
  @StateObject var viewModel = CommunitiesViewModel()
  @Environment(\.dismiss) var dismiss

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
        }
        VStack {
          Text("Editando Vecino")
            .font(.system(size: 28, weight: .semibold, design: .rounded))
            .padding(.top, 50)
        }
        Spacer()
        ScrollView {
          VStack {
            TextField("Nombre de Vecino", text: $viewModel.editNombreVecino)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.horizontal)
              .autocapitalization(.none)
            TextField("Piso", text: $viewModel.editPisoVecino)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.horizontal)
              .autocapitalization(.none)
              // .keyboardType(.numberPad)
              .onReceive(Just(viewModel.editPisoVecino)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                  viewModel.editPisoVecino = filtered
                }
              }
            TextField("Letra de piso", text: $viewModel.editLetraVecino)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.horizontal)
              .autocapitalization(.none)
            TextField("Teléfono", text: $viewModel.editTelefonoVecino)
              .shadow(color: Color.white, radius: 4, x: 0, y: 1)
              .shadow(color: Color.black, radius: 1, x: 1, y: 1)
              .padding()
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.horizontal)
              .autocapitalization(.none)
              // .keyboardType(.numberPad)
              .onReceive(Just(viewModel.editTelefonoVecino)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                  viewModel.editTelefonoVecino = filtered
                }
              }
          }
          HStack {
            Button("Actualizar") {
              Task {
                if viewModel.editPisoVecino != "" && viewModel.editNombreVecino != "" && viewModel.editLetraVecino != "" && viewModel.editTelefonoVecino != "" {
                  viewModel.editVecino = AddNeighbourModel(
                    _rev: viewModel.editRevVecino,
                    tabla: viewModel.editTablaVecino,
                    piso: Int(viewModel.editPisoVecino)!,
                    letra: viewModel.editLetraVecino,
                    nombre: viewModel.editNombreVecino,
                    telefono: Int(viewModel.editTelefonoVecino)!,
                    comunidad: viewModel.editComunidadVecino
                  )
                  print(viewModel.editVecino)
                  do {
                    try await viewModel.updateNeighbour()
                    viewModel.foundNeighbours = []
                  } catch {
                    print("Error actualizando el vecino: \(error.localizedDescription)")
                  }

                } else {
                  print("Rellena todos los campos")
                }
              }
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20, weight: .semibold))
            .padding()
            .tint(.orange)
            Button("Eliminar Vecino") {
              Task {
                await viewModel.deleteNeighbor()
                // Usando Environment Dismiss, permite cerrar modales como este NavigationLink
                dismiss()
              }
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20, weight: .semibold))
            .padding()
            .tint(.red)
          }
        }

        .onAppear {
          print(viewModel.editVecino)
          viewModel.editNombreVecino = viewModel.editNombreVecino
          viewModel.editPisoVecino = viewModel.editPisoVecino
          viewModel.editLetraVecino = viewModel.editLetraVecino
          viewModel.editTelefonoVecino = viewModel.editTelefonoVecino
          viewModel.foundNeighbours = []
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(LinearGradient(colors: [.white, .white, .white, .purple], startPoint: .bottomLeading, endPoint: .top))
    }
  }
}

struct EditNeighbourView_Previews: PreviewProvider {
  static var previews: some View {
    EditNeighbourView()
  }
}
