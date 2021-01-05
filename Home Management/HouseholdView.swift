//
//  HouseholdView.swift
//  Home Management
//
//  Created by Paul Vasile on 02.12.2020.
//

import SwiftUI

struct HouseholdView: View {
    @ObservedObject var taskListVM: TaskListViewModel
    
    @State var showManageMembers = false
    @State var showAddTask = false
    @State private var updateInterface = false
    @State private var hiddenButton = "Show completed tasks"
    @Binding var exitedHome: Bool
    @Environment(\.presentationMode) var presentationMode
    private let home: HouseholdModel
    
    init(home: HouseholdModel, exitedHome: Binding<Bool>) {
        taskListVM = TaskListViewModel(home: home)
        self.home = home
        self._exitedHome = exitedHome
    }
    
    var body: some View {
    
        NavigationView {
              VStack(alignment: .leading) {
                Button(action: {
                    self.updateInterface.toggle()
                }, label: {
                    Text(self.hiddenButton)
                }).padding(.leading, 17)
                List {
                  ForEach (taskListVM.taskCellViewModels) { taskCellVM in
                    TaskCell(taskCellVM: taskCellVM)
                  }
                  .onDelete { indexSet in
                    self.taskListVM.removeTasks(atOffsets: indexSet)
                  }
                  
                }
                .onChange(of: updateInterface, perform: { value in
                    taskListVM.loadData(home: home, filter: hiddenButton)
                    if self.hiddenButton == "Show completed tasks" {
                        self.hiddenButton = "Hide completed tasks"
                    } else {
                        self.hiddenButton = "Show completed tasks"
                    }
                })
                .onChange(of: exitedHome, perform: { value in
                    self.presentationMode.wrappedValue.dismiss()
                })
                
                Button(action: {
                    self.showAddTask.toggle()
                }) {
                  HStack {
                    Image(systemName: "plus.circle.fill")
                      .resizable()
                      .frame(width: 20, height: 20)
                    Text("New Task")
                  }
                }
                .sheet(isPresented: $showAddTask, content: {
                    CreateTask(home: home, fromParent: $updateInterface)
                })
                .padding()
                .accentColor(Color(UIColor.systemRed))
              }
              .navigationBarTitle(home.name)
              .navigationBarItems(trailing:
                                    Button("Manage people") {
                                        self.showManageMembers.toggle()
                                    }
                                    .sheet(isPresented: $showManageMembers, content: {
                                        ManageMembers(home: home, exitedHome: $exitedHome)
                                    }))
        }
    }
}

struct TaskCell: View {
    
    @ObservedObject var taskCellVM: TaskCellViewModel
    @State private var sessionKey = UserDefaults.standard.string(forKey: "UserSession")!
    
      var onCommit: (Result<Task, InputError>) -> Void = { _ in }
      
      var body: some View {
        HStack {
          Image(systemName: taskCellVM.completionStateIconName)
            .resizable()
            .frame(width: 20, height: 20)
            .onTapGesture {
                self.taskCellVM.task.status.toggle()
                print(String(taskCellVM.task.id))
                guard let url = URL(string: ServerData.shared.address + ServerData.shared.task_status) else {
                    print("Invalid URL")
                    return
                }
                let params = ["home":String(taskCellVM.home.id), "task":String(taskCellVM.task.id), "status": 1] as Dictionary<String, Any>
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(sessionKey)", forHTTPHeaderField: "Authorization")
                URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if httpResponse.statusCode == 200{
                            
                            DispatchQueue.main.async {
                                
                                print("Marked as done")
                                
                            }
                            
                        }else{
                            print("Not ok")
                        }
                    }
                }.resume()
            }
          TextField("Enter task title", text: $taskCellVM.task.title, // (3)
                    onCommit: { //(4)
                      if !self.taskCellVM.task.title.isEmpty {
                        self.onCommit(.success(self.taskCellVM.task))
                      }
                      else {
                        self.onCommit(.failure(.empty))
                      }
          }).id(taskCellVM.id)
        }
      }
}

enum InputError: Error {
  case empty
}
