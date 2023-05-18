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

  //==============================LOGIN============================
  var body: some View {
    if !viewModel.isLogged {
      // Vista Login
      Login(viewModel: viewModel)

      //============================TABVIEW GENERAL=================================

    } else {
      TabView {
        Group {
          // Usuario
          UserView(currentUser: $viewModel.currentUser, viewModel: viewModel)
            .tabItem {
              Label("Usuario", systemImage: "person.circle.fill")
            }
            .background(LinearGradient(colors: [.white, .white, .white, .blue], startPoint: .bottomLeading, endPoint: .top))
          //==============================COMUNIDADES=================================

          if viewModel.userRole == "ADMIN" {
            CommunityView(viewModel: viewModel)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .tabItem {
                Label("Comunidades", systemImage: "building.2.fill")
              }
              .background(LinearGradient(colors: [.white, .white, .white, .red], startPoint: .bottomLeading, endPoint: .top))

            //==================VECINOS======================================

            NeighbourView(viewModel: viewModel)
              .tabItem {
                Label("Vecinos", systemImage: "person.3.fill")
              }
              .onAppear {
                print("Id de comunidad seleccionada: \(viewModel.selectedCommunityId)")
              }
              .background(LinearGradient(colors: [.white, .white, .white, .purple], startPoint: .bottomLeading, endPoint: .top))
         

          //==================REUNIONES======================================
            MeetingsView(viewModel: viewModel)
          
            .tabItem {
              Label("Reuniones", systemImage: "list.bullet.clipboard.fill")
            }
            .background(LinearGradient(colors: [.white, .white, .white, .yellow], startPoint: .bottomLeading, endPoint: .top))
            
          }
            
            if viewModel.userRole == "Vecino"{
                neibMeetingsView(viewModel: viewModel)
              
                .tabItem {
                  Label("Reuniones", systemImage: "list.bullet.clipboard.fill")
                }
                .background(LinearGradient(colors: [.white, .white, .white, .yellow], startPoint: .bottomLeading, endPoint: .top))
            }
            
            
        }
        .toolbarColorScheme(.light, for: .tabBar)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
