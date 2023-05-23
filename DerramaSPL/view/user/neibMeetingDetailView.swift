//
//  neibMeetingDetailView.swift
//  DerramaSPL
//
//  Created by Suar Palazon Losa on 23/5/23.
//

import SwiftUI

struct neibMeetingDetailView: View {
  var meeting: MeetingDataModel

  var body: some View {
    VStack {
      Text(meeting.nombre)
        .font(.system(size: 18, weight: .semibold, design: .rounded))
      Text(meeting.fecha)
        .foregroundColor(.blue)
    }
    ScrollView {
      VStack {
        VStack {
          Divider()
          Button("Confirmar asistencia") {
            print("Asistencia confirmada")
            // Aquí editaríamos la reunión, en la que este id de vecino cambiaría asiste a true
          }

          .buttonStyle(.borderedProminent)
          .tint(.secondary)

          Divider()
        }
      }
    }
  }
}
