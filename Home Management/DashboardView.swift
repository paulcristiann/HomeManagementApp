//
//  DashboardView.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject private var DashboardVM = DashboardViewModel()
    @ObservedObject private var taskListVM = TaskListViewModel()
    @State private var ShowSettingsSheet = false
    @State private var UpdateInterface = false
    @State private var ShowAddHomeSheet = false
    @State private var SelectedHome: HouseholdModel?
        
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("My Day")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(DashboardVM.CurrentTime)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("My households")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        self.ShowSettingsSheet.toggle()
                    }){
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                            .imageScale(.large)
                            .padding(.trailing, 20)
                    }
                    .sheet(isPresented: $ShowSettingsSheet, content: {
                        SettingsView()
                    })
                }
                .padding(.leading, 20.0)
                .padding(.top, 20.0)
            }
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                
                HStack {
                    ForEach(DashboardVM.Homes){ home in
                        
                        Button(action: {
                            self.SelectedHome = home
                        }, label: {
                            HouseholdCardView(title: home.name, numberOfTasks: 10)
                        })
                        
                    }
                    Button(action: {
                        self.ShowAddHomeSheet.toggle()
                    }, label: {
                        AddHouseholdView()
                    })
                    .onChange(of: UpdateInterface, perform: { value in
                        self.DashboardVM.setupDataPublisher()
                    })
                    .sheet(item: self.$SelectedHome) { home in
                        HouseholdView(home: home, exitedHome: $UpdateInterface)
                   }

                }
                .padding(.leading, 20.0)
            })
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("My tasks")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            self.UpdateInterface.toggle()
                        }, label: {
                            Text("Refresh tasks")
                        }).padding(.top, 5)
                        .padding(.bottom, 10)
                        .foregroundColor(.white)
                        .onChange(of: UpdateInterface, perform: { value in
                            self.taskListVM.taskCellViewModels.removeAll()
                            self.taskListVM.getAllTasks(homes: taskListVM.homes_list)
                        })
                        
                        if taskListVM.taskCellViewModels.count != 0 {
                                  ForEach (taskListVM.taskCellViewModels) { taskCellVM in
                                    TaskCell(taskCellVM: taskCellVM)
                                  }
                                  .onDelete { indexSet in
                                    self.taskListVM.removeTasks(atOffsets: indexSet)
                                  }
                        } else {
                            Text("All tasks completed")
                                .padding(.top, 20)
                                .foregroundColor(.white)
                        }
                }
                Spacer()
            }
                
                .padding(.leading, 20.0)
            }
            .sheet(isPresented: $ShowAddHomeSheet, content: {
                AddHome(valueFromParent: $UpdateInterface)
            })
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
}
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
