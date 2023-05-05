//
//  Meetings.swift
//  DerramaSPL
//
//  Created by Suar PL on 6/5/23.
//

import SwiftUI

struct MeetingsView: View {
  @StateObject var viewModel = CommunitiesViewModel()
  
  
  var body: some View {
    VStack {
      VStack {
        HStack {
          Label("Reuniones", systemImage: "building.2.fill")
            .padding()
            .font(.system(size: 21, weight: .bold))
          Image("logoapp")
            .resizable()
            .frame(width: 170, height: 60)
            .shadow(color: Color.black, radius: 5, x: 1, y: 1)
            .shadow(color: Color.white, radius: 4, x: 0, y: 1)
            .padding(.leading, 34)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .font(.system(size: 28, weight: .semibold, design: .rounded))
        .foregroundColor(Color.black)
        .background(.ultraThinMaterial)
      }
      
      Spacer()

      VStack {
        Text("Reuniones/Mensajes")
          .font(.system(size: 36, weight: .semibold, design: .rounded))
          .padding()
          .padding(.top, 30)
        Text("\(viewModel.selectedCommunityName)")
          .font(.system(size: 24, weight: .semibold, design: .rounded))
          .padding()

        }
        Spacer()
        
        NavigationStack{
          List{
            NavigationLink {
              ScrollView{
                Text("CONTENIDO REUNIONES")
              }
            } label: {
              Label("Reuniones", systemImage: "list.bullet.clipboard.fill")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            NavigationLink {
              ScrollView{
                Text("CONTENIDO MENSAJES")
              }
            } label: {
              Label("Mensajes", systemImage: "ellipsis.message.fill")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
          }
          .scrollContentBackground(.hidden)
        }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.white, .white, .white,.white,  .orange], startPoint: .bottomLeading, endPoint: .top))
  }
}

struct MeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingsView()
    }
}
