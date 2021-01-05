//
//  RegisterViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 30.12.2020.
//

import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    
    @Published var RegisterStatus = false
    @Published var RegisterMessage = ""
    @Published var ShowAlert = false
    @Published var DismissRegister = false
    
    private var anyCancellable: AnyCancellable?
    
    func setupDataPublisher(name: String, username: String, email: String, password: String) {
        //Configure the request
        var request = URLRequest(url: URL(string: ServerData.shared.address + ServerData.shared.register)!)
        let parameters = ["name": name, "user": username, "email": email, "password":password] as Dictionary<String, Any>
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        anyCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                        DispatchQueue.main.async {
                            self.RegisterMessage = "Register Failed"
                            self.ShowAlert.toggle()
                        }
                    throw URLError(.badServerResponse)
                }
            return data
            }
            .decode(type: UserRegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { response in
                DispatchQueue.main.async {
                    self.RegisterMessage = "Your account has been created."
                    self.ShowAlert.toggle()
                    self.DismissRegister.toggle()
                }
            }
    }
}
