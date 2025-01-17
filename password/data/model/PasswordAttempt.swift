//
//  PasswordAttempt.swift
//  password
//
//  Created by Markus Thielker on 17.01.25.
//

import Foundation
import SwiftData

@Model
class PasswordAttempt: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var password: UUID
    
    var timestamp: Date
    var isSuccessful: Bool
    var typingTime: Double
    
    init(id: UUID = UUID(), password: UUID, timestamp: Date = Date(), isSuccessful: Bool, typingTime: Double) {
        self.id = id
        self.password = password
        self.timestamp = timestamp
        self.isSuccessful = isSuccessful
        self.typingTime = typingTime
    }
}
