//
//  UserModel.swift
//  Home Management
//
//  Created by Paul Vasile on 26.11.2020.
//

import Foundation

struct UserModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let user: String
    let email: String
    let password: String?
}
