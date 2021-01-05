//
//  LoginViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 30.12.2020.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    @Published var LoginStatus = false
    @Published var LoginMessage = ""
    @Published var ShowAlert = false
    
    private var anyCancellable: AnyCancellable?
    
    func setupDataPublisher(username: String, password: String) {
        //Configure the request
        var request = URLRequest(url: URL(string: ServerData.shared.address + ServerData.shared.login)!)
        let parameters = ["user":username, "password":password] as Dictionary<String, Any>
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        anyCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                        DispatchQueue.main.async {
                            self.LoginMessage = "Login Failed"
                            self.ShowAlert.toggle()
                        }
                    throw URLError(.badServerResponse)
                }
            return data
            }
            .decode(type: UserLoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { response in
                UserDefaults.standard.set(response.user.id, forKey: "UserId")
                UserDefaults.standard.set(response.user.name, forKey: "UserFullName")
                UserDefaults.standard.set(response.user.user, forKey: "UserNickname")
                UserDefaults.standard.set(response.user.email, forKey: "UserEmail")
                UserDefaults.standard.set(response.token, forKey: "UserSession")
                self.LoginStatus.toggle()
            }
    }
}
