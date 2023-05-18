//
//  neibMeetings.swift
//  DerramaSPL
//
//  Created by Suar Palazon Losa on 12/5/23.
//

import SwiftUI

struct neibMeetingsView: View {
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

        VStack {
          Text("Reuniones/Avisos")
            .font(.system(size: 36, weight: .semibold, design: .rounded))
            .padding(.bottom)
            .padding(.top, 30)
          Text("\(viewModel.selectedCommunityName)")
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .padding()
        }

        NavigationStack {
          List {
            // Navlink reuniones
            NavigationLink {
              ScrollView {
                Text("CONTENIDO REUNIONES vista vecino")
                    
              }
            } label: {
              Label("Reuniones", systemImage: "list.bullet.clipboard.fill")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .navigationTitle("")

           
            NavigationLink {
            

              VStack {
                Divider()
                  Label("Lista de avisos", systemImage: "ellipsis.message.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 18))
                    .padding(.top, 10)
              }
              ScrollView {
                ForEach(viewModel.notices, id: \._id) { notice in
                  VStack(alignment: .leading) {
                    VStack {
                      if notice.texto != "" && notice.fecha != "" {
                        Divider()
                        HStack {
                          Text("Aviso: ")
                            .font(.headline)

                          Text("\(notice.texto)")

                            Button("Borrar") {
                                viewModel.showAlert = true
                                }
                                .alert(isPresented: $viewModel.showAlert) {
                                    Alert(
                                        title: Text("Función no disponible"),
                                        message: Text("Endpoint no implementado " +
                                                        "en el backend.")
                                    )
                                }
                          .buttonStyle(.borderedProminent)
                          .tint(.red)
                        }.padding()

                        Text("Fecha: \(notice.fecha)")
                          .font(.subheadline)
                          .foregroundColor(.gray)

                        Divider()
                      } else {
                      }
                    }
                  }
                }
              }
              .onAppear {
                Task {
                  await viewModel.getNotifications()
                }
              }
            } label: {
              Label("Avisos", systemImage: "ellipsis.message.fill")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .navigationTitle("")
          }
          .scrollContentBackground(.hidden)
          Spacer()
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(LinearGradient(colors: [.white, .white, .white, .white, .orange], startPoint: .bottomLeading, endPoint: .top))
    }
  }


struct neibMeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        neibMeetingsView()
    }
}
