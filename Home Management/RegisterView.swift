//
//  RegisterView.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI

struct RegisterView: View {
    
        // MARK: - Propertiers
        @ObservedObject private var RegisterVM = RegisterViewModel()
        @State private var UserFullName = ""
        @State private var UserNickname = ""
        @State private var UserEmail = ""
        @State private var UserPassword = ""
        @Environment(\.presentationMode) var presentationMode
        
        // MARK: - View
        var body: some View {
            ScrollView{
                
                VStack() {
                    
                    Text("Register for an account")
                        .font(.largeTitle).foregroundColor(Color.white)
                        .padding([.top, .bottom], 10)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        TextField("Full name", text: self.$UserFullName)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                            .autocapitalization(.none)
                        
                        TextField("Username", text: self.$UserNickname)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                            .autocapitalization(.none)
                        
                        TextField("Email", text: self.$UserEmail)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: self.$UserPassword)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }.padding([.leading, .trailing], 27.5)
                    
                    Button(action: {
                        
                        RegisterVM.setupDataPublisher(name: UserFullName, username: UserNickname, email: UserEmail, password: UserPassword)
                        
                    }) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }.padding(.top, 20)
                    .alert(isPresented: $RegisterVM.ShowAlert) {
                        Alert(title: Text(RegisterVM.RegisterMessage))
                    }
                    .onChange(of: RegisterVM.DismissRegister, perform: { value in
                        if RegisterVM.DismissRegister {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                    
                    Spacer()
                    
                }
                .padding(.top, 100)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all))
        }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
