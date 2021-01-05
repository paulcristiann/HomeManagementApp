//
//  DashboardViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 30.12.2020.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published public var Homes = [HouseholdModel]()
    @Published public var CurrentTime = ""
    
    private var UserSession = UserDefaults.standard.string(forKey: "UserSession")!
    private var anyCancellable: AnyCancellable?
    
    init() {
        setupDataPublisher()
        setupTimerPublisher()
    }
    
    func setupDataPublisher() {
        //Configure the request
        var request = URLRequest(url: URL(string: ServerData.shared.address + ServerData.shared.list_homes)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(UserSession)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        anyCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                        print("Fetch failed")
                    throw URLError(.badServerResponse)
                }
            return data
            }
            .decode(type: [HouseholdModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { response in
                DispatchQueue.main.async {
                    self.Homes = response
                }
            }
    }
    
    func setupTimerPublisher() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM d, yyyy"
        let formattedDate = format.string(from: date)
        self.CurrentTime = formattedDate
    }
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .medium
        return df
    }()
    
}
