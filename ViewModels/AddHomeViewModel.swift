//
//  AddHomeViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 30.12.2020.
//

import Foundation
import Combine

final class AddHomeViewModel: ObservableObject {
    @Published var AddStatus = false
    @Published var AddMessage = ""
    @Published var ShowAlert = false
    @Published var DismissAdd = false
    
    private var UserSession = UserDefaults.standard.string(forKey: "UserSession")!
    private var anyCancellable: AnyCancellable?
    
    func setupDataPublisher(name: String) {
        //Configure the request
        var request = URLRequest(url: URL(string: ServerData.address + Endpoints.create_home)!)
        let parameters = ["name": name] as Dictionary<String, Any>
        request.httpMethod = "POST"
        request.addValue("Bearer \(UserSession)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        anyCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                        DispatchQueue.main.async {
                            self.AddMessage = "Add home Failed"
                            self.ShowAlert.toggle()
                            print(response.description)
                        }
                    throw URLError(.badServerResponse)
                }
            return data
            }
            .decode(type: HouseholdModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { response in
                DispatchQueue.main.async {
                    self.AddMessage = "Your home was created."
                    self.DismissAdd.toggle()
                }
            }
    }
}
