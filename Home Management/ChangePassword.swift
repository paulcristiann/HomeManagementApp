//
//  ChangePassword.swift
//  Home Management
//
//  Created by Paul Vasile on 29.11.2020.
//

import SwiftUI

struct ChangePassword: View {
    
    @State private var newPassword = ""
    @State private var showsAlert = false
    @State private var alertText = ""
    @State private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView{
            VStack() {
                Text("Change your password")
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("New password", text: self.$newPassword)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .autocapitalization(.none)
                    
                }.padding([.leading, .trailing], 27.5)
                
                Button(action: {
                    
                    let params = ["password":newPassword] as Dictionary<String, String>

                    var request = URLRequest(url:URL(string: ServerData.shared.address + ServerData.shared.reset)!)
                    
                    request.httpMethod = "POST"
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                    request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                    let session = URLSession.shared
                    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                        if let httpResponse = response as? HTTPURLResponse {
                        
                            if httpResponse.statusCode == 200{
                                
                                self.presentationMode.wrappedValue.dismiss()
                            
                            }else{
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, String>
                                    
                                    alertText = json["message"]!
                                    self.showsAlert.toggle()
                                    
                                } catch {
                                    print("error")
                                }
                            }
                        }
                    })
                    task.resume()
                }) {
                    Text("Update")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 20)
                .alert(isPresented: $showsAlert, content: {
                    Alert(title: Text(alertText))
                })
                
            }.padding(.top, 20)
                
                Spacer()
                
            }
            .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))}
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}
