//
//  Password.swift
//  password
//
//  Created by Markus Thielker on 15.01.25.
//

import Foundation

struct Password: Identifiable, Codable {
    let id: UUID
    let name: String
    let value: String
    var createdAt: Date = Date()
    
    init(id: UUID = UUID(), name: String, value: String) {
        self.id = id
        self.name = name
        self.value = value
    }
}
