//
//  ContentView.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    // MARK: - Propertiers
        @ObservedObject private var LoginVM = LoginViewModel()
        @State private var username = ""
        @State private var password = ""
        @State private var showRegisterSheet = false
        
        // MARK: - View
        var body: some View {
                ScrollView{
                    VStack() {
                        Text("Home Management")
                            .font(.largeTitle).foregroundColor(Color.white)
                            .padding([.top, .bottom], 10)
                            .shadow(radius: 10.0, x: 20, y: 10)
                        
                        Image("app_logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10.0, x: 20, y: 10)
                            .padding(.bottom, 20)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Username")
                                .font(.headline).foregroundColor(Color.white)
                                .padding([.top, .bottom], 10)
                                .shadow(radius: 10.0, x: 20, y: 10)
                            TextField("Username", text: self.$username)
                                .padding()
                                .background(Color.themeTextField)
                                .cornerRadius(20.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                                .autocapitalization(.none)
                            
                            Text("Password")
                                .font(.headline).foregroundColor(Color.white)
                                .padding([.top, .bottom], 10)
                                .shadow(radius: 10.0, x: 20, y: 10)
                            SecureField("Password", text: self.$password)
                                .padding()
                                .background(Color.themeTextField)
                                .cornerRadius(20.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }.padding([.leading, .trailing], 27.5)
                        
                        Button(action: {
                            
                            print("Logging in to the app")
                            LoginVM.setupDataPublisher(username: username, password: password)
                            
                        }) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }.padding(.top, 20)
                        .alert(isPresented: $LoginVM.ShowAlert) {
                            Alert(title: Text(LoginVM.LoginMessage))
                        }.fullScreenCover(isPresented: $LoginVM.LoginStatus, content: {
                            DashboardView()
                        })
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Text("Don't have an account? ")
                            Button("Sign Up") {
                                self.showRegisterSheet = true
                            }
                        }.padding(.top, 10)
                        .sheet(isPresented: $showRegisterSheet, content: {
                            RegisterView()
                        })
                        
                    }
                    .padding()
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
            }
            }

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
