//
//  MeetingDetailView.swift
//  DerramaSPL
//
//  Created by Suar Palazon Losa on 19/5/23.
//

import SwiftUI

struct MeetingDetailView: View {
  var meeting: MeetingDataModel

  var body: some View {
    VStack {
      Text(meeting.nombre)
        .font(.system(size: 18, weight: .semibold, design: .rounded))
      Text(meeting.fecha)
            .foregroundColor(.blue)
    }
      ScrollView{
          VStack {
              if let vecinos = meeting.vecinos {
                  ForEach(vecinos.indices, id: \.self) { index in
                      
                      VStack{
                          Divider()
                          Text("Vecino convocado \(index + 1)")
                              .font(.system(size: 16, weight: .semibold, design: .rounded))
                          Divider()
                          Text("ID: \(vecinos[index].vecino != nil ? (vecinos[index].vecino!) : "Desconocido")")
                          Text("Asistencia: \(vecinos[index].asiste != nil ? ("Confirmada") : "No confirmada")")
                      }
                      
                  }
                  
                  
              } else {
                  Text("No hay vecinos convocados")
              }
          }
          
      }
      
  }
}
