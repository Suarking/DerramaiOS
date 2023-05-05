//
//  LoginView.swift
//  DerramaSPL
//
//  Created by Suar PL on 4/5/23.
//

import SwiftUI

struct Login: View {
  @StateObject var viewModel = CommunitiesViewModel()
  //@Binding var isLogged: Bool
  //@State var username: String = ""
  //@State var password: String = ""
  
  var body: some View {
    ZStack {
      Image("back")
        .resizable()
        .frame(width: 400, height: 900)
      
      VStack {
        Spacer()
        
        VStack(alignment: .leading) {
          Image("logoapp")
            .resizable()
            .frame(width: 360, height: 120)
            .shadow(color: Color.black, radius: 5, x: 1, y: 1)
            .shadow(color: Color.white, radius: 4, x: 0, y: 1)
            .shadow(color: Color.black, radius: 1, x: 1, y: 1)
        }
        VStack {
          VStack(spacing: 0) {
            (Text(Image(systemName: "person.fill"))
             + Text("  Login"))
            .foregroundColor(.white)
            .frame(width: 360, height: 60)
            .font(.title)
            .shadow(color: Color.black, radius: 5, x: 1, y: 1)
            .padding(.top, 100)
            Divider()
              .frame(width: 200, height: 2)
              .overlay(.white)
          }
          
          TextField("Nombre de Usuario", text: $viewModel.username)
            .shadow(color: Color.white, radius: 4, x: 0, y: 1)
            .shadow(color: Color.black, radius: 1, x: 1, y: 1)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .autocapitalization(.none)
          SecureField("Contraseña", text: $viewModel.password)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .shadow(color: Color.white, radius: 4, x: 0, y: 1)
            .shadow(color: Color.black, radius: 1, x: 1, y: 1)
            .padding(.horizontal)
          
          Button("Iniciar Sesión") {
            Task {
              await viewModel.login(username: viewModel.username, password: viewModel.password)
              //self.isLogged = viewModel.isLogged
            }
            
            
          }
          .buttonStyle(.borderedProminent)
          .font(.system(size: 21, weight: .semibold))
          .foregroundColor(Color.white)
          .shadow(color: Color.black, radius: 1, x: 0, y: 0)
          .shadow(color: Color.purple, radius: 5, x: 0, y: 0)
          .tint(.black)
          .padding()
        }
        .shadow(color: Color.black, radius: 5, x: 1, y: 1)
        .cornerRadius(30)
        
        Spacer()
        Spacer()
        Spacer()
      }
    }
    .onAppear{
      viewModel.username = ""
      viewModel.password = ""
    }
  }
   
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(viewModel: CommunitiesViewModel())
    }
}
