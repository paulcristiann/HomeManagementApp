//
//  TaskListViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 02.12.2020.
//

import Foundation
import Combine

final class TaskListViewModel: ObservableObject {
    
    @Published var taskCellViewModels = [TaskCellViewModel]()
    @Published var homes_list = [HouseholdModel]()
    
    private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    private var userEmail = UserDefaults.standard.string(forKey: "UserEmail")!
    private var cancellables = Set<AnyCancellable>()
    
    init(home: HouseholdModel) {
        getTasksFromHome(home: home)
    }
    
    init() {
        //Configure the request
        var request = URLRequest(url: URL(string: ServerData.address + Endpoints.list_homes)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
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
                    self.homes_list = response
                    self.getAllTasks(homes: self.homes_list)
                }
            }.store(in: &cancellables)
    }

    func getAllTasks(homes: [HouseholdModel]) {
        print(homes)
        for home in homes {
            var request = URLRequest(url: URL(string: ServerData.address + Endpoints.task_list + "?home=" + String(home.id))!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                            print("Fetch failed")
                        throw URLError(.badServerResponse)
                    }
                return data
                }
                .decode(type: [Task].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { response in
                    DispatchQueue.main.async {
                        print(response)
                        let filtered_tasks = response.filter {$0.status == false && $0.assignee?.email == self.userEmail}
                        self.taskCellViewModels.append(contentsOf: filtered_tasks.map { task in
                            TaskCellViewModel(task: task, home: home)
                        })
                        print(self.taskCellViewModels)
                    }
                }.store(in: &cancellables)
        }
    }
    
    func getTasksFromHome(home: HouseholdModel) {
        guard let url = URL(string: ServerData.address + Endpoints.task_list + "?home=" + String(home.id)) else {
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
                        
                        let tasks: [Task] = try! JSONDecoder().decode([Task].self, from: data!)
                        let filtered_tasks = tasks.filter {$0.status == false}
                        self.taskCellViewModels = filtered_tasks.map { task in
                            TaskCellViewModel(task: task, home: home)
                        }
                    }
                    
                }else{
                    
                }
            }
        }.resume()
    }
    
    func removeTasks(atOffsets indexSet: IndexSet) {
        let task = taskCellViewModels[indexSet.first!]
        guard let url = URL(string: ServerData.address + Endpoints.task_delete) else {
            print("Invalid URL")
            return
        }
        let params = ["home":task.task.home, "task":task.task.id] as Dictionary<String, Int>
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200{
                    
                    DispatchQueue.main.async {
                        print("Deleted from server")
                        self.taskCellViewModels.remove(atOffsets: indexSet)
                    }
                    
                }else{
                    print("Delete failed " + response!.debugDescription)
                }
            }
        }.resume()
    }
  
//    func addTask(task: Task) {
//        taskCellViewModels.append(TaskCellViewModel(task: task, home: house))
//    }
    
    func loadData(home: HouseholdModel, filter: String) {
        guard let url = URL(string: ServerData.address + Endpoints.task_list + "?home=" + String(home.id)) else {
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
                        
                        let tasks: [Task] = try! JSONDecoder().decode([Task].self, from: data!)
                        if filter == "Show completed tasks" {
                            self.taskCellViewModels = tasks.map { task in
                                TaskCellViewModel(task: task, home: home)
                            }
                        } else {
                            let filtered_tasks = tasks.filter {$0.status == false}
                            self.taskCellViewModels = filtered_tasks.map { task in
                                TaskCellViewModel(task: task, home: home)
                            }
                        }
                    }
                    
                } else {
                    print("Fetch tasks failed")
                }
            }
        }.resume()
    }
}
