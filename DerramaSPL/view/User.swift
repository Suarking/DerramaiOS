//
//  User.swift
//  DerramaSPL
//
//  Created by Suar PL on 4/5/23.
//

import SwiftUI

struct UserView: View {
  @Binding var currentUser: String
  @StateObject var viewModel = CommunitiesViewModel()

  var body: some View {
    VStack {
      HStack {
        Label("Usuario", systemImage: "person.circle.fill")
          .padding()
          .font(.system(size: 21, weight: .bold))

        Image("logoapp")
          .resizable()
          .frame(width: 170, height: 60)
          .shadow(color: Color.black, radius: 5, x: 1, y: 1)
          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
          .padding(.leading, 67)
      }
      .frame(maxWidth: .infinity)
      .frame(height: 60)
      .font(.system(size: 28, weight: .semibold, design: .rounded))
      .foregroundColor(Color.black)
      .background(.ultraThinMaterial)

      Spacer()
      VStack {
        Text("¡Bienvenido \(currentUser)!")
          .font(.system(size: 36, weight: .semibold, design: .rounded))
          .padding()
          .padding(.top, 30)
        Spacer()
        Text("Actualmente logueado como \(viewModel.userRole)")
          .padding()

        // Vista condicional - Solo visible para vecino
        if viewModel.userRole == "Vecino" {
          Text("Residente en \(viewModel.selectedCommunityName)")
        }

        Spacer()
        Text("Selecciona una Comunidad en la pestaña Comunidades para empezar a gestionarla")
          .foregroundColor(.blue)
          .padding()
        Button(action: {
          print("cerrando sesion")
          viewModel.logout()
          viewModel.isLogged = false
        }, label: {
          Text("Cerrar Sesión")
        })
        .buttonStyle(.borderedProminent)
        .font(.system(size: 20, weight: .semibold))
        .padding()
        Spacer()
        Spacer()
      }
      .onAppear {
        // MARK: - SIMULANDO ASIGNACIÓN DE COMUNIDADES

        // Al haber solo 3 usuarios (v1,v2,v3) sin relación con los vecinos, asignamos
        // v1 y v3 a la comunidad 1, y v2 a la comunidad 2
        Task {
          if viewModel.userRole == "Vecino" {
            if currentUser == "v1" || currentUser == "v3" {
              viewModel.selectedCommunityIndex = 0
              await viewModel.getCommunities()
              viewModel.selectedCommunityName = viewModel.communities[viewModel.selectedCommunityIndex].nombre
              viewModel.selectedCommunityId = viewModel.communities[viewModel.selectedCommunityIndex]._id
            }
            if currentUser == "v2" {
              viewModel.selectedCommunityIndex = 1
              await viewModel.getCommunities()
              viewModel.selectedCommunityName = viewModel.communities[viewModel.selectedCommunityIndex].nombre
              viewModel.selectedCommunityId = viewModel.communities[viewModel.selectedCommunityIndex]._id
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.white, .white, .white, .blue], startPoint: .bottomLeading, endPoint: .top))
  }

  struct User_Previews: PreviewProvider {
    static var previews: some View {
      UserView(currentUser: Binding.constant("SuarPL"), viewModel: CommunitiesViewModel())
    }
  }
}
