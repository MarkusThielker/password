//
//  PasswordManager.swift
//  password
//
//  Created by Markus Thielker on 17.01.25.
//

import Foundation
import SwiftUICore
import SwiftData

class PasswordManager {
    
    let passwordRepository: PasswordRepository
    let passwordAttemptRepository: PasswordAttemptRepository
    let passwordKeychainRepository: PasswordKeychainRepository
    
    private let context: ModelContext
    
    init(
        context: ModelContext,
        passwordRepository: PasswordRepository,
        passwordAttemptRepository: PasswordAttemptRepository,
        passwordKeychainRepository: PasswordKeychainRepository
    ) {
        self.context = context
        self.passwordRepository = passwordRepository
        self.passwordAttemptRepository = passwordAttemptRepository
        self.passwordKeychainRepository = passwordKeychainRepository
    }
    
    @MainActor
    func getAllPasswords() -> [Password] {
        return passwordRepository.getAllPasswords()
    }
    
    @MainActor
    func getPassword(withID id: UUID) -> Password? {
        return passwordRepository.getPassword(withID: id)
    }
    
    func getPasswordKeychain(withID id: UUID) -> PasswordKC? {
        return passwordKeychainRepository.getPassword(withID: id)
    }
    
    func getPasswordAttempts(passwordID id: UUID) -> [PasswordAttempt] {
        return passwordAttemptRepository.getPasswordAttempts(passwordID: id)
    }
    
    @MainActor
    func createPassword(name: String, value: String) -> Password {
        
        print("creating password \(name)")
        
        let password = Password(name: name)
        
        do {

            try context.transaction {
                passwordRepository.createPassword(password)
                let passwordKC = PasswordKC(id: password.id, value: value)
                try passwordKeychainRepository.createPassword(passwordKC)
            }
            
            print("password created successfully")
            
        } catch {
            context.rollback()
            print("password creation failed: \(error)")
        }
                
        return password
    }
    
    @MainActor
    func createPasswordAttempt(passwordID: UUID, isSuccessful: Bool, typingTime: Double) {
        let attempt = PasswordAttempt(
            password: passwordID,
            isSuccessful: isSuccessful,
            typingTime: typingTime
        )
        passwordAttemptRepository.createPasswordAttempt(attempt: attempt)
    }
    
    @MainActor
    func deletePassword(_ password: Password) -> Bool {
        
        print("deleting password \(password.name)")
        
        var successful = false
        
        do {

            try context.transaction {
                passwordRepository.deletePassword(password)
                try passwordAttemptRepository.deleteAllAttempts(withID: password.id)
                try passwordKeychainRepository.deletePassword(withID: password.id)
            }
            
            successful = true
            print("password deleted successfully")
            
        } catch {
            context.rollback()
            print("password deletion failed: \(error)")
        }
                
        return successful
    }
}
