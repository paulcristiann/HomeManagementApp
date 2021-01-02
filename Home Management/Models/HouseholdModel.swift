//
//  HouseholdModel.swift
//  Home Management
//
//  Created by Paul Vasile on 28.11.2020.
//

import Foundation

struct HouseholdModel: Decodable, Identifiable {
    var id: Int
    var name: String
    var owner: Int
}
