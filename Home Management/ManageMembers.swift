//
//  ManageMembers.swift
//  Home Management
//
//  Created by Paul Vasile on 23.12.2020.
//

import SwiftUI

struct ManageMembers: View {
    
    @State private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    @State private var email = UserDefaults.standard.string(forKey: "UserEmail")!
    @State private var users = [UserModel]()
    @State public var home: HouseholdModel
    @State private var showAddmember = false
    @State private var updateInterface = false
    @Binding var exitedHome: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            List{
                ForEach(users, id: \.id) { item in
                    Text(item.email)
                }
                .onDelete { indexSet in
                    self.removeMember(atOffsets: indexSet)
                }
            }
            .onAppear(perform: loadData)
            .onChange(of: updateInterface, perform: { value in
                loadData()
            })
            .navigationBarTitle("People in " + home.name)
            .navigationBarItems(trailing:
                            Button("Add member") {
                                self.showAddmember.toggle()
                            })
            .sheet(isPresented: $showAddmember, content: {
                AddMemberHome(home: home, valueFromParent: $updateInterface)
            })
        }
    }
    
    func loadData() {
        
        guard let url = URL(string: ServerData.shared.address + ServerData.shared.list_members + "?home=" + String(home.id)) else {
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
    
    func removeMember(atOffsets indexSet: IndexSet) {
        let user = users[indexSet.first!]
        guard let url = URL(string: ServerData.shared.address + ServerData.shared.remove_member) else {
            print("Invalid URL")
            return
        }
        let params = ["home":home.id, "user":user.id] as Dictionary<String, Any>
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200{
                    
                    DispatchQueue.main.async {
                        print("Deleted from server")
                        self.users.remove(atOffsets: indexSet)
                        if user.email == self.email {
                            self.exitedHome.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }else{
                    print("Delete failed " + response!.debugDescription)
                }
            }
        }.resume()
    }
}
