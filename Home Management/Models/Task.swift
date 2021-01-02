//
//  Task.swift
//  Home Management
//
//  Created by Paul Vasile on 02.12.2020.
//

import Foundation

struct Task: Decodable, Identifiable{
    var id: Int
    var home: Int
    var title: String
    var status: Bool
    var assignee: UserModel?
}
