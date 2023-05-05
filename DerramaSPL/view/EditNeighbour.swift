//
//  EditNeighbour.swift
//  DerramaSPL
//
//  Created by Suar PL on 6/5/23.
//

import SwiftUI
import Combine

struct EditNeighbourView: View {
  @StateObject var viewModel = CommunitiesViewModel()

  @State private var editPisoVecino = ""
  @State private var editTelefonoVecino = ""
  
  var body: some View {
    
    VStack{
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
        Text("Editando \(viewModel.editVecino.nombre)")
          .font(.system(size: 28, weight: .semibold, design: .rounded))
          .padding(.top, 50)
      }
      Spacer()
      ScrollView{
        Text("Contenido Edición Vecinos")
        TextField("Nombre de Vecino", text: $viewModel.editVecino.nombre)
          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
          .padding()
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.horizontal)
          .autocapitalization(.none)
        TextField("Piso", text: $editPisoVecino)
          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
          .padding()
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.horizontal)
          .autocapitalization(.none)
        // .keyboardType(.numberPad)
          .onReceive(Just(editPisoVecino)) { newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
              editPisoVecino = filtered
            }
          }
        TextField("Letra de piso", text: $viewModel.editVecino.letra)
          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
          .padding()
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.horizontal)
          .autocapitalization(.none)
        TextField("Teléfono", text: $editTelefonoVecino)
          .shadow(color: Color.white, radius: 4, x: 0, y: 1)
          .shadow(color: Color.black, radius: 1, x: 1, y: 1)
          .padding()
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.horizontal)
          .autocapitalization(.none)
        // .keyboardType(.numberPad)
          .onReceive(Just(editTelefonoVecino)) { newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
              editTelefonoVecino = filtered
            }
          }
      }
      
      .onAppear{
        print(viewModel.editVecino)
        editPisoVecino = String(viewModel.editVecino.piso)
        editTelefonoVecino = String(viewModel.editVecino.telefono)
      }
      
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.white, .white, .white, .purple], startPoint: .bottomLeading, endPoint: .top))
  }
    
    
}
 


struct EditNeighbourView_Previews: PreviewProvider {
    static var previews: some View {
        EditNeighbourView()
    }
}
