//
//  Home_ManagementApp.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI

@main
struct Home_ManagementApp: App {
    
    @State private var isLoggedIn = UserDefaults.standard.string(forKey: "UserSession")
    @State private var session = UserDefaults.standard.integer(forKey: "UserSession")
    
    var body: some Scene {
        WindowGroup {
            if (isLoggedIn != nil){
                DashboardView()
            }else{
                LoginView()
            }
        }
    }
}

class ServerData {
    
    static let shared = ServerData()
    
    init() {}
    
    let address = "https://anca.pslr.me"
    let register = "/auth/register"
    let login = "/auth/login"
    let reset = "api/account/reset"
    let create_home = "/api/homes/create"
    let list_homes = "/api/homes/list"
    let leave_home = "/api/homes/leave"
    let get_member = "/api/members/get"
    let list_members = "/api/members/list"
    let add_member = "/api/members/add"
    let remove_member = "/api/members/remove"
    let task_list = "/api/tasks/list"
    let task_create = "/api/tasks/create"
    let task_delete = "/api/tasks/delete"
    let task_assign = "/api/tasks/assign"
    let task_status = "/api/tasks/status"
    
}
