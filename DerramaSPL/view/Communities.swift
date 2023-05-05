//
//  Communities.swift
//  DerramaSPL
//
//  Created by Suar PL on 4/5/23.
//

import SwiftUI

struct CommunityView: View {
  @StateObject var viewModel = CommunitiesViewModel()
  @State var localSelection: String = ""

  var body: some View {
    VStack {
      VStack {
        HStack {
          Label("Comunidades", systemImage: "building.2.fill")
            .padding()
            .font(.system(size: 21, weight: .bold))
          Image("logoapp")
            .resizable()
            .frame(width: 170, height: 60)
            .shadow(color: Color.black, radius: 5, x: 1, y: 1)
            .shadow(color: Color.white, radius: 4, x: 0, y: 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .font(.system(size: 28, weight: .semibold, design: .rounded))
        .foregroundColor(Color.black)
        .background(.ultraThinMaterial)
      }
      VStack {
        if viewModel.selectedCommunityName != "" {
          Text("Administrando \(viewModel.selectedCommunityName)")
            .font(.system(size: 28, weight: .semibold, design: .rounded))
          
        } else {
          Text("Selecciona una comunidad")
            .font(.system(size: 28, weight: .semibold, design: .rounded))
            .padding(.top, 20)
        }
      }

      VStack {
        if viewModel.selectedCommunityName != "" {
          VStack {
            Image("community")
              .resizable()
              .cornerRadius(30)
              .shadow(radius: 10)
              .frame(width: 250, height: 250)

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
              .padding(10)
          }
        }
        Spacer()
        VStack {
          Picker("Selecciona Comunidad", selection: $localSelection) {
            ForEach(viewModel.communities, id: \._id) { community in
              Text(community.nombre).tag(community.nombre)
            }
          }
          .pickerStyle(.inline)
          .background(Color.red.opacity(0.05))
          .frame(width: 300, height: 100)
          .cornerRadius(30)
          .padding()
        }

        Button(action: {
          viewModel.selectedCommunityName = localSelection
          viewModel.getCommunityIndex()

          print(viewModel.communities[viewModel.selectedCommunityIndex])

        }, label: {
          Text("Seleccionar Comunidad")
        })
          .buttonStyle(.borderedProminent)
          .font(.system(size: 20, weight: .semibold))
      }

      .padding()
      .onAppear {
        Task {
          await viewModel.getCommunities()
          viewModel.foundNeighbours = []
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.white, .white, .white, .red], startPoint: .bottomLeading, endPoint: .top))
  }
}

struct Communities_Previews: PreviewProvider {
  static var previews: some View {
    CommunityView()
  }
}
