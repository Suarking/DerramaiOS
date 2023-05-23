//
//  Meetings.swift
//  DerramaSPL
//
//  Created by Suar PL on 6/5/23.
//

import SwiftUI

struct MeetingsView: View {
  @StateObject var viewModel = CommunitiesViewModel()
  @State var aviso = ""
    @State var motivoReunion = ""
    @State var vecinosConvocados : [Vecino] = []
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

      if viewModel.selectedCommunityName == "" {
          //Comunidad no seleccionada, vista condicional
        VStack {
          Text("Selecciona antes una comunidad para comenzar")
            .font(.system(size: 28, weight: .semibold, design: .rounded))
            .padding(.top, 50)
        }
        .multilineTextAlignment(.center)
      } else {
        VStack {
          Text("Reuniones/Avisos de \(viewModel.selectedCommunityName)")
            .font(.system(size: 28, weight: .semibold, design: .rounded))
            .multilineTextAlignment(.center)
            .padding(.vertical, 30)
        }
        .onAppear {
          Task {
              viewModel.foundMeetings = []
            await viewModel.getMeetings()
            self.meetings = viewModel.foundMeetings
          }
        }

        NavigationStack {
          List {
            // Navlink reuniones
            NavigationLink {
              VStack {
                // Navlink publicar reuniones
                  NavigationLink {
                    VStack {
                      Text("Convocar reunión en \(viewModel.selectedCommunityName)")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding()

                      VStack(alignment: .leading, spacing: 0) {
                        Text("Fecha:")
                          .font(.system(size: 14, weight: .semibold, design: .rounded))
                          .padding(.leading, 40)

                        TextField("Fecha", text: $currentDate, axis: .vertical)
                          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                          .padding()
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding(.horizontal)
                          .textInputAutocapitalization(.never)
                          .autocorrectionDisabled(true)
                      }
                      VStack(alignment: .leading, spacing: 0) {
                        Text("Motivo:")
                          .font(.system(size: 14, weight: .semibold, design: .rounded))
                          .padding(.leading, 40)
                        TextField("Motivo reunión", text: $motivoReunion, axis: .vertical)
                          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                          .padding()
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding(.horizontal)
                          .textInputAutocapitalization(.characters)
                          .autocorrectionDisabled(true)
                      }
                      VStack {
                        Button("Convocar a todos los vecinos") {
                            if currentDate != "" && motivoReunion != ""{
                                Task {
                                    await viewModel.getAllNeighbors()
                                    await viewModel.addMeeting(fecha: currentDate, nombre: motivoReunion, vecinos: viewModel.meetNeighbours)
                                    
                                  
                                }
                            }else{
                                print("Introduce una fecha y un motivo")
                            }
                         
                        }
                      
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .tint(.green)
                      }
                    }
                    Spacer()
                    Spacer()
                } label: {
                  Label("Convocar Reunión", systemImage: "list.bullet.clipboard.fill")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .navigationTitle("")
                .buttonStyle(.borderedProminent)
                .tint(Color.blue.gradient)
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
                  }else{
                      VStack(alignment: .leading) {
                        ForEach(meetings.indices, id: \.self) { index in

                          NavigationLink(destination: MeetingDetailView(meeting: meetings[index])) {
                            if meetings[index].nombre != "" {
                              VStack(alignment: .leading) {
                                Divider()
                                HStack {
                                  Label(meetings[index].nombre, systemImage: "list.bullet.clipboard.fill")
                                    .multilineTextAlignment(.leading)
                                    .tint(.black)
                                  Button("Anular") {
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
                                }
                                .padding(.horizontal)
                              }
                            }
                          }
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
                // Navlink anyadir aviso
                NavigationLink {
                  VStack {
                    Text("Publicar aviso en \(viewModel.selectedCommunityName)")
                      .font(.system(size: 18, weight: .semibold, design: .rounded))
                      .padding()

                    VStack(alignment: .leading, spacing: 0) {
                      Text("Fecha:")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.leading, 40)

                      TextField("Fecha", text: $currentDate, axis: .vertical)
                        .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                        .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                      Text("Aviso:")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.leading, 40)
                      TextField("Aviso", text: $aviso, axis: .vertical)
                        .lineLimit(4 ... 6)
                        .shadow(color: Color.white, radius: 4, x: 0, y: 1)
                        .shadow(color: Color.black, radius: 1, x: 1, y: 1)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    }
                    VStack {
                      Button("Publicar") {
                        Task {
                          await viewModel.addAviso(comunidadID: viewModel.selectedCommunityId, texto: aviso, fecha: currentDate)
                          alertAviso = true
                        }
                      }
                      .alert(isPresented: $alertAviso) {
                        Alert(
                          title: Text("Aviso Publicado"),
                          message: Text("Aviso publicado correctamente.")
                        )
                      }
                      .buttonStyle(.borderedProminent)
                      .font(.system(size: 20, weight: .semibold))
                      .padding()
                      .tint(.green)
                    }
                  }
                  Spacer()
                  Spacer()

                } label: {
                  Label("Publicar Aviso", systemImage: "ellipsis.message.fill")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .navigationTitle("")
                .buttonStyle(.borderedProminent)
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
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.white, .white, .white, .white, .orange], startPoint: .bottomLeading, endPoint: .top))
  }
}

struct MeetingsView_Previews: PreviewProvider {
  static var previews: some View {
    MeetingsView()
  }
}
