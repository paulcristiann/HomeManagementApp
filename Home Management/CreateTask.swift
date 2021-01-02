//
//  CreateTask.swift
//  Home Management
//
//  Created by Paul Vasile on 13.12.2020.
//

import SwiftUI

struct CreateTask: View {
    
    @State private var taskName = ""
    @State private var selection = 0
    @State private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    @State public var users = [UserModel]()
    @State public var home: HouseholdModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var fromParent: Bool
    
    var body: some View {
        ScrollView{
            VStack() {
                Text("Create a new Task")
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Task description", text: self.$taskName)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .autocapitalization(.none)
                    
                    Text("Assign to")
                        .font(.title).foregroundColor(Color.white)
                        .padding([.top, .bottom], 10)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    Picker("Suggest a topping for:", selection: $selection) {
                        ForEach(users) { item in
                            Text(item.email)
                                .tag(item.id)
                        }
                    }
                    
                }.padding([.leading, .trailing], 27.5)
                .onAppear(perform: loadData)
                
                Button(action: {
                    
                    self.uploadTask()
                    
                }) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 20)
                
            }.padding(.top, 20)
                
            Spacer()
                
            }
            .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))}
    
    func loadData() {
        
        guard let url = URL(string: ServerData.address + Endpoints.list_members + "?home=" + String(home.id)) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200{
                    
                    DispatchQueue.main.async {
                        
                        let users: [UserModel] = try! JSONDecoder().decode([UserModel].self, from: data!)
                        self.users = users
                        
                    }
                    
                }else{
                    
                }
            }
        }.resume()
    }
    
    func uploadTask() {
        guard let url = URL(string: ServerData.address + Endpoints.task_create) else {
            print("Invalid URL")
            return
        }
        let params = ["home":home.id, "title":taskName] as Dictionary<String, Any>
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200{
                    
                    DispatchQueue.main.async {
                        
                        //Decode task
                        let task: Task = try! JSONDecoder().decode(Task.self, from: data!)
                        print(task.title)
                        
                        //Task created, now assign to user
                        guard let url2 = URL(string: ServerData.address + Endpoints.task_assign) else {
                            print("Invalid URL")
                            return
                        }
                        if selection == 0 {
                            selection = users[0].id
                        }
                        let params2 = ["home":home.id, "task":task.id, "user":selection] as Dictionary<String, Any>
                        var request2 = URLRequest(url: url2)
                        request2.httpMethod = "POST"
                        request2.httpBody = try? JSONSerialization.data(withJSONObject: params2, options: [])
                        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request2.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
                        URLSession.shared.dataTask(with: request2) { data2, response2, error2 in
                            
                            if let httpResponse2 = response2 as? HTTPURLResponse {
                                
                                if httpResponse2.statusCode == 200{
                                    
                                    DispatchQueue.main.async {
                                        print("Task assigned")
                                        self.fromParent.toggle()
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                }else{
                                    print(request2)
                                    print(params2)
                                    print("Assign failed " + response2.debugDescription)
                                }
                            }
                        }.resume()
                    }
                    
                }else{
                    print("Task creation failed")
                }
            }
        }.resume()
    }
}
