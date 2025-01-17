//
//  ListViewModel.swift
//  password
//
//  Created by Markus Thielker on 16.01.25.
//

import Foundation
import SwiftData

class ListViewModel: ObservableObject {
    
    @Published var passwords: [Password] = []
    
    private let context: ModelContext
    private let passwordManager: PasswordManager

    @MainActor
    init(context: ModelContext) {
        self.context = context
        
        let passwordRepository = PasswordRepository(context)
        let passwordKeychainRepository = PasswordKeychainRepository()
        
        self.passwordManager = PasswordManager(
            context: context,
            passwordRepository: passwordRepository,
            passwordKeychainRepository: passwordKeychainRepository
        )
        
        passwords = getAllPasswords()
    }
    
    @MainActor
    func getAllPasswords() -> [Password] {
        return passwordManager.getAllPasswords()
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
    func createPassword(name: String, value: String) {
        passwordManager.createPassword(name: name, value: value)
        passwords = getAllPasswords()
    }
    
    @MainActor
    func deletePassword(_ password: Password) {
        let success = passwordManager.deletePassword(password)
        if success {
            passwords = getAllPasswords()
        }
    }
}
