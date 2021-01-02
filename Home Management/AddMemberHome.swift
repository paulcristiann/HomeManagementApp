//
//  AddMemberHome.swift
//  Home Management
//
//  Created by Paul Vasile on 23.12.2020.
//

import SwiftUI

struct AddMemberHome: View {
    @State private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    @State private var userEmail = ""
    @State public var home: HouseholdModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var valueFromParent : Bool
    @State private var showsAlert = false
    @State private var alertText = ""
    
    var body: some View {
        ScrollView{
            VStack() {
                Text("Add a member in " + home.name)
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("User email", text: self.$userEmail)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .autocapitalization(.none)
                    
                }.padding([.leading, .trailing], 27.5)
                
                Button(action: {
                    
                    self.loadData()
                    
                }) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 20)
                .alert(isPresented: self.$showsAlert) {
                    Alert(title: Text(alertText))
                }
                
            }.padding(.top, 20)
                
            Spacer()
                
            }
            .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
    }
    
    func loadData() {
        
        guard let url = URL(string: ServerData.address + Endpoints.add_member) else {
            print("Invalid URL")
            return
        }
        let params = ["home":String(home.id), "user":userEmail] as Dictionary<String, String>
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200{
                    
                    DispatchQueue.main.async {
                        self.valueFromParent.toggle()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }else{
                    self.alertText = "The user does not exist"
                    self.showsAlert.toggle()
                }
            }
        }.resume()
    }
}
