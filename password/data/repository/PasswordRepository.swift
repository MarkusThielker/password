//
//  PasswordRepository.swift
//  password
//
//  Created by Markus Thielker on 17.01.25.
//

import Foundation
import SwiftUICore
import SwiftData

class PasswordRepository {
    
    private let context: ModelContext
    
    init(_ context: ModelContext) {
        self.context = context
    }
    
    @MainActor
    func getAllPasswords() -> [Password] {
        
        print("fetching passwords")

        var passwords: [Password] = []
        do {
            
            let request = FetchDescriptor<Password>()
            passwords = try context.fetch(request)
            
            print("found \(passwords.count) passwords")
            
        } catch {
            print("fetching password failed: \(error)")
        }

        return passwords
    }
    
    @MainActor
    func getPassword(withID id: UUID) -> Password? {
        
        print("fetching password with id \(id)")
        
        var password: Password?
        do {
            
            let request = FetchDescriptor<Password>(predicate: #Predicate { $0.id == id })
            password = try context.fetch(request).first
        
            print("found password: \(password == nil)")
            
        } catch {
            print("fetching password failed: \(error)")
        }
        
        return password
    }
    
    @MainActor
    func createPassword(_ password: Password) {
        context.insert(password)
        print("inserted password \(password.name)")
    }
    
    @MainActor
    func deletePassword(_ password: Password) {
        context.delete(password)
        print("deleted password \(password.name)")
    }
}
