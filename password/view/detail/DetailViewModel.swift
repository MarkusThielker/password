//
//  ListViewModel.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation
import SwiftData

class DetailViewModel: ObservableObject {
        
    let passwordID: UUID
    
    private let context: ModelContext
    private let passwordManager: PasswordManager
    
    @Published var password: Password
    @Published var passwordKC: PasswordKC
    @Published var passwordAttempts: [PasswordAttempt]

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
