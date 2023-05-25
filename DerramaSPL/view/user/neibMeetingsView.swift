//
//  neibMeetings.swift
//  DerramaSPL
//
//  Created by Suar Palazon Losa on 12/5/23.
//

import SwiftUI

struct neibMeetingsView: View {
  @StateObject var viewModel = CommunitiesViewModel()
  @State var aviso = ""
  @State var currentDate = Date.now.formatted(date: .long, time: .shortened)
  @State var dateSelection = ""
  @State var alertAviso: Bool = false
  @State var meetings: [MeetingDataModel] = []

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
        Text("Reuniones/Avisos de \(viewModel.selectedCommunityName)")
          .font(.system(size: 28, weight: .semibold, design: .rounded))
          .multilineTextAlignment(.center)
          .padding(.vertical, 30)
      }
      .onAppear {
        Task {
          await viewModel.getMeetings()
          self.meetings = viewModel.foundMeetings
        }
      }

      NavigationStack {
        List {
          // Navlink reuniones
          NavigationLink {
            VStack {
              Text("")
            }
            VStack {
              Divider()
              Label("Listado de reuniones", systemImage: "list.bullet.clipboard.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
              Text("Pulsa en el nombre de la reunión para ver detalles")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .padding(.bottom, 5)
            }
            .background(Color.orange.gradient.opacity(0.7))
            .border(.gray)
            ScrollView {
              // Recuperar reuniones
              if viewModel.foundMeetings.count == 0 {
                Text("No se han podido recuperar las reuniones")
                Text("Inconsistencia de datos en BD")
              } else {
                VStack(alignment: .leading) {
                  ForEach(meetings.indices, id: \.self) { index in

                    NavigationLink(destination: neibMeetingDetailView(meeting: meetings[index])) {
                      if meetings[index].nombre != "" {
                        VStack(alignment: .leading) {
                          Divider()
                          HStack {
                            Label(meetings[index].nombre, systemImage: "list.bullet.clipboard.fill")
                              .multilineTextAlignment(.leading)
                              .tint(.black)
                          }
                          .padding(.horizontal)
                        }
                      }
                    }
                    .navigationTitle("")
                  }
                }
              }
            }
            .onAppear {
              self.meetings = viewModel.foundMeetings
            }
          } label: {
            Label("Reuniones", systemImage: "list.bullet.clipboard.fill")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
          }
          .navigationTitle("")

          // Navlink avisos
          NavigationLink {
            VStack {
              Text("")
            }
            VStack {
              Divider()
              Label("Listado de avisos", systemImage: "ellipsis.message.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.vertical, 5)
            }
            .background(Color.orange.gradient.opacity(0.7))
            .border(.gray)

            ScrollView {
              // Recuperar avisos
              ForEach(viewModel.notices, id: \._id) { notice in
                VStack(alignment: .leading) {
                  VStack {
                    if notice.texto != "" && notice.fecha != "" {
                      Divider()
                      HStack {
                        Text("Aviso: ")
                          .font(.headline)

                        Text("\(notice.texto)")

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
                await viewModel.getMeetings()
              }
            }
          } label: {
            Label("Avisos", systemImage: "ellipsis.message.fill")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
          }
          .navigationTitle("")
        }
        .scrollContentBackground(.hidden)
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
