//
//  SettingsView.swift
//  Home Management
//
//  Created by Paul Vasile on 04/11/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var userFullName = UserDefaults.standard.string(forKey: "UserFullName")!
    @State private var userEmail = UserDefaults.standard.string(forKey: "UserEmail")!
    @State private var userName = UserDefaults.standard.string(forKey: "UserNickname")!
    @State private var isLoggedOut = false
    @State private var showChangePassword = false
    
    var body: some View {
            
        NavigationView{
         
            Form{
                
                Section(header: Text("Account details")){
                    Text("Full name: " + userFullName)
                    Text("Username: " + userName)
                    Text("Email: " + userEmail)
                    Button(action: {
                    
                        self.showChangePassword.toggle()
                        
                    }, label: {
                        Text("Change password")
                    }).sheet(isPresented: $showChangePassword, content: {
                        ChangePassword()
                    })
                }
                
                Section(header: Text("App settings")){
                    Text("Server IP: " + ServerData.address)
                }
                
                Section{
                    Button(action: {
                    
                        UserDefaults.standard.removeObject(forKey: "Session")
                        self.isLoggedOut.toggle()
                        
                    }, label: {
                        Text("Logout")
                            .foregroundColor(.red)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }).fullScreenCover(isPresented: $isLoggedOut, content: {
                        LoginView()
                    })
                }
            }.navigationBarTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
