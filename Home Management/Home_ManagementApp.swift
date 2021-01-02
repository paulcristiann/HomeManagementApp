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

struct Endpoints {
    static let register = "/auth/register"
    static let login = "/auth/login"
    static let reset = "api/account/reset"
    static let create_home = "/api/homes/create"
    static let list_homes = "/api/homes/list"
    static let leave_home = "/api/homes/leave"
    static let get_member = "/api/members/get"
    static let list_members = "/api/members/list"
    static let add_member = "/api/members/add"
    static let remove_member = "/api/members/remove"
    static let task_list = "/api/tasks/list"
    static let task_create = "/api/tasks/create"
    static let task_delete = "/api/tasks/delete"
    static let task_assign = "/api/tasks/assign"
    static let task_status = "/api/tasks/status"
}

struct ServerData {
    static let address = "https://anca.pslr.me"
}
