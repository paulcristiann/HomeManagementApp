//
//  UserLoginResponse.swift
//  Home Management
//
//  Created by Paul Vasile on 26.11.2020.
//

import Foundation

struct UserLoginResponse: Decodable {
    let token: String
    let user: UserModel
}
