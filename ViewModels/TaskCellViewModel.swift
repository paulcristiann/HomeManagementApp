//
//  TaskCellViewModel.swift
//  Home Management
//
//  Created by Paul Vasile on 02.12.2020.
//

import Foundation
import Combine

final class TaskCellViewModel: ObservableObject, Identifiable  {
  @Published var task: Task
  @Published var home: HouseholdModel
  
  var id: Int = 0
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  static func newTask() -> TaskCellViewModel {
    TaskCellViewModel(task: Task(id: 1, home: 1, title: "Test task", status: false, assignee: UserModel(id: 1, name: "Paul", user: "paul", email: "paul", password: "1234")), home: HouseholdModel(id: 1, name: "Test", owner: 1))
  }
  
    init(task: Task, home: HouseholdModel) {
        
    self.task = task
    self.home = home

    $task
        .map { $0.status ? "checkmark.circle.fill" : "circle" }
        .assign(to: \.completionStateIconName, on: self)
        .store(in: &cancellables)

    $task
        .map { $0.id }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)

  }
  
}
