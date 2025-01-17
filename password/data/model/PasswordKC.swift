//
//  PasswordKC.swift
//  password
//
//  Created by Markus Thielker on 17.01.25.
//

import Foundation

struct PasswordKC: Identifiable, Codable {
    
    let id: UUID
    let value: String
    
    init(id: UUID, value: String) {
        self.id = id
        self.value = value
    }
}
