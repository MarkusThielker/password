//
//  ListViewModel.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation
import SwiftData

struct PasswordAttemptStatistics {
    let totalCount: Int
    let successCount: Int
    let successRate: Double
    let averageTime: Double
}

class DetailViewModel: ObservableObject {
        
    let passwordID: UUID
    
    private let context: ModelContext
    private let passwordManager: PasswordManager
    
    @Published var password: Password
    @Published var passwordKC: PasswordKC
    @Published var passwordAttempts: [PasswordAttempt]
    
    var statistics: PasswordAttemptStatistics {
        guard !passwordAttempts.isEmpty else {
            return PasswordAttemptStatistics(
                totalCount: 0,
                successCount: 0,
                successRate: 0.00,
                averageTime: 0.00
            )
        }

        let totalCount = passwordAttempts.count
        let successCount = passwordAttempts.filter { $0.isSuccessful }.count
        let successRate = Double(successCount) / Double(totalCount) * 100
        let averageTime = passwordAttempts.count > 0 ? passwordAttempts.reduce(0) { $0 + $1.typingTime } / Double(passwordAttempts.count) : 0

        return PasswordAttemptStatistics(
            totalCount: totalCount,
            successCount: successCount,
            successRate: successRate,
            averageTime: averageTime
        )
    }

    @MainActor
    init(context: ModelContext, passwordID id: UUID) {
        self.context = context
        self.passwordID = id
        
        let passwordRepository = PasswordRepository(context)
        let passwordAttemptRepository = PasswordAttemptRepository(context)
        let passwordKeychainRepository = PasswordKeychainRepository()
        
        self.passwordManager = PasswordManager(
            context: context,
            passwordRepository: passwordRepository,
            passwordAttemptRepository: passwordAttemptRepository,
            passwordKeychainRepository: passwordKeychainRepository
        )
        
        password = passwordManager.getPassword(withID: id)!
        passwordKC = passwordManager.getPasswordKeychain(withID: id)!
        passwordAttempts = passwordManager.getPasswordAttempts(passwordID: id)
    }
    
    @MainActor
    func getPassword(withID id: UUID) -> Password? {
        return passwordManager.getPassword(withID: id)
    }
    
    @MainActor
    func getPasswordKeychain(withID id: UUID) -> PasswordKC? {
        return passwordManager.getPasswordKeychain(withID: id)
    }
    
    @MainActor
    func createPasswordAttempt(isSuccessful: Bool, typingTime: Double) {
        passwordManager.createPasswordAttempt(passwordID: password.id, isSuccessful: isSuccessful, typingTime: typingTime)
        passwordAttempts = passwordManager.getPasswordAttempts(passwordID: password.id)
    }
}
