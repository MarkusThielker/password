//
//  Password.swift
//  password
//
//  Created by Markus Thielker on 15.01.25.
//

import Foundation
import SwiftData

@Model
class Password: Identifiable {
    
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var createdAt: Date = Date()
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
